#!/bin/bash
#d Create a temp security group for current ip, start an ec2 instance and ssh to it

#u AWS_ACCESS_KEY_ID='' AWS_SECRET_ACCESS_KEY='' ./start_temp_ssh_ec2.sh [vpc-id subnet-id]

set -o nounset
#set -o xtrace
set -o errexit

EC2_AMI="ami-0ce71448843cb18a1" # Amazon Linux 2
KEYPAIR_NAME="DefaultKPIreland"
KEYPAIR_PATH='~/Downloads/DefaultKPIreland.pem'
CONNECT_MAX_RETRY=60
cur_ip=$(curl -4 -s ifconfig.co)
tmp_loc=$(mktemp)

if [ "$#" -ne 2 ];
then
  echo "Using default VPC & subnets"
  vpc_id_fmt="";
  subnet_id_fmt="";
else
  echo "Using vpc: ${1} - subnet: ${2}"
  vpc_id_fmt="--vpc-id ${1}"
  subnet_id_fmt="--subnet-id ${2}"
fi;


echo "Current ip: ${cur_ip}"

function connect_instance_id () {
  instance_pubip=$(
    aws ec2 describe-instances \
      --filters Name=instance-id,Values=${1} \
    | jq -r \
      '.Reservations[0] .Instances[0] .PublicIpAddress'
  )
  echo "Connecting to ${instance_pubip}"

  osascript -e "display notification \"${instance_pubip} up\" with title \"${0}\"" || true
  ssh \
    -i ${KEYPAIR_PATH} \
    -o 'StrictHostKeyChecking=no' \
    ec2-user@${instance_pubip}
}

echo -n "Creating temporary security group ... "
SG_ID=$(\
  aws ec2 create-security-group \
    --description "Allow ssh from ${cur_ip}" \
    --group-name "ssh22-tcp-${cur_ip}-tmp${RANDOM}" \
    ${vpc_id_fmt} \
  | jq -r '.GroupId'
)
echo "✔️  (${SG_ID})"

echo -n "Creating security group rule for ${cur_ip}/32 ... "
aws ec2 authorize-security-group-ingress \
  --group-id ${SG_ID} \
  --protocol tcp \
  --port 22 \
  --cidr "${cur_ip}/32"
echo "✔️ "

echo -n "Starting ec2 instance ... "
aws ec2 run-instances \
  --image-id ${EC2_AMI} \
  --count 1 \
  --instance-type t2.micro \
  --key-name ${KEYPAIR_NAME} \
  --security-group-ids ${SG_ID} \
  --associate-public-ip-address  \
  ${subnet_id_fmt} \
  > ${tmp_loc}

instance_id=$(\
  cat ${tmp_loc} \
  | grep InstanceId \
  | cut -d '"' -f 4
)
echo "✔️  (${instance_id})"

echo "Waiting instance ${instance_id} to be ready ... "

i=0
while [ ${i} -lt ${CONNECT_MAX_RETRY} ];
do
    aws ec2 describe-instance-status \
      --instance-ids ${instance_id} \
      > ${tmp_loc}
    instance_state=$(cat ${tmp_loc} | jq -r '.InstanceStatuses[0] .InstanceState .Name')
    instance_status=$(cat ${tmp_loc} | jq -r '.InstanceStatuses[0] .InstanceStatus .Status')
    instance_pubip=$(
      aws ec2 describe-instances \
        --filters Name=instance-id,Values=${instance_id} \
      | jq -r \
        '.Reservations[0] .Instances[0] .PublicIpAddress'
    )

    echo -n -e "(retry ${i}/${CONNECT_MAX_RETRY})\tState: ${instance_state}\tStatus: ${instance_status}\t\tPublic IP: ${instance_pubip}"
    #connect ${instance_pubip} exit
    set -e
    ssh_exit_code=0
    ssh \
      -i ${KEYPAIR_PATH} \
      -o 'StrictHostKeyChecking=no' \
      -o 'ConnectTimeout=3' \
      -o 'ConnectionAttempts=1' \
      -q \
      ec2-user@${instance_pubip} exit 0 || ssh_exit_code=$?
    #echo "Last exit code: ${ssh_exit_code}"
    if [ ${ssh_exit_code} -eq 0 ];
    then
      echo -e "\t✔️"
      osascript -e "display notification \"${instance_pubip} up\" with title \"${0}\"" || true
      ssh \
        -i ${KEYPAIR_PATH} \
        -o 'StrictHostKeyChecking=no' \
        -q \
        ec2-user@${instance_pubip}
      #connect_instance_id ${instance_id}
      break ;
    fi;
    echo -n -e "\r"
    sleep 1
    i=$((i+1));
done;

echo -n "Terminating instance ${instance_id} ... "
aws ec2 terminate-instances \
  --instance-ids ${instance_id} \
  > ${tmp_loc}
aws ec2 wait instance-terminated \
  --instance-ids ${instance_id}
echo '✔️'

osascript -e "display notification \"Instance ${instance_id} terminated\" with title \"${0}\"" || true

echo -n "Deleting temporary security group ${SG_ID} "
aws ec2 delete-security-group \
  --group-id ${SG_ID} \
  > ${tmp_loc}
echo '✔️'

rm -rf ${tmp_loc}
