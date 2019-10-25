#!/bin/bash
#d Create a temp security group for current ip, start an ec2 instance and ssh to it

#u ./start_temp_ssh_ec2.sh

set -o nounset
#set -o xtrace
set -o errexit

EC2_AMI="ami-0ce71448843cb18a1" # Amazon Linux 2
KEYPAIR_NAME="DefaultKPIreland"
KEYPAIR_PATH='~/Downloads/DefaultKPIreland.pem'
cur_ip=$(curl -s ifconfig.co)
tmp_loc=$(mktemp)

echo "Current ip: ${cur_ip}"

function connect_instance_id () {
  instance_pubip=$(
    aws ec2 describe-instances \
      --filters Name=instance-id,Values=${1} \
    | jq -r \
      '.Reservations[0] .Instances[0] .PublicIpAddress'
  )
  echo "Connecting to ${instance_pubip}"
  ssh \
    -i ${KEYPAIR_PATH} \
    -o 'StrictHostKeyChecking=no' \
    ec2-user@${instance_pubip}
}

echo -n "Creating temporary security group ... "

SG_ID=$(\
  aws ec2 create-security-group \
    --description "Allow ssh from ${cur_ip}" \
    --group-name 'ssh22tcp-current_ip-tmp' \
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
  > ${tmp_loc}

instance_id=$(\
  cat ${tmp_loc} \
  | grep InstanceId \
  | cut -d '"' -f 4
)
echo "✔️  (${instance_id})"

echo "Waiting instance ${instance_id} to be ready ... "

while [ 1 ];
do
    aws ec2 describe-instance-status \
      --instance-ids ${instance_id} \
      > ${tmp_loc}
    instance_state=$(cat ${tmp_loc} | jq -r '.InstanceStatuses[0] .InstanceState .Name')
    instance_status=$(cat ${tmp_loc} | jq -r '.InstanceStatuses[0] .InstanceStatus .Status')
    echo -n -e "\tState: ${instance_state} - Status: ${instance_status} ... "
    if [ "${instance_state}" = "running" ] && [ "${instance_status}" == "ok" ];
    then
      echo '✔️'
      connect_instance_id ${instance_id}
      break ;
    fi;
    echo -n -e "                                                                                                      \r"
    sleep 2
done;

echo -n "Terminating instance ${instance_id} ... "
aws ec2 terminate-instances \
  --instance-ids ${instance_id} \
  > ${tmp_loc}
aws ec2 wait instance-terminated \
  --instance-ids ${instance_id}
echo '✔️'

echo -n "Deleting temporary security group ${SG_ID} "
aws ec2 delete-security-group \
  --group-id ${SG_ID} \
  > ${tmp_loc}
echo '✔️'

rm -rf ${tmp_loc}
