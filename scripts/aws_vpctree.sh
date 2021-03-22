#!/bin/bash
#u aws_list_vpc.sh

#d List vpcs, subnets, nat gtw & instances of current aws account

#set -o nounset
set -o errexit
set -o pipefail
# set -o xtrace
# set -o verbose

function describe_vpcs() {
	local vpc_id="${1}"

	if [ "${vpc_id}" = "" ];
	then
		aws ec2 describe-vpcs
	else
		aws ec2 describe-vpcs --filter Name=vpc-id,Value=${vpc_id}
	fi;
}

function describe_vpc_resource_type() {
	local vpc_id=${1}
	local vpc_resource_type=${2}

	if [ "${vpc_id}" != "" ];
	then
		aws ec2 describe-${2} --filter Name=vpc-id,Values=${vpc_id}
	fi;
}

function filter_json() {
	local json="${1}"
	local filter="${2}"

	echo -n "${json}" | jq -r "${filter}"
}

function fmt_line() {
	local indent_lvl=${1}
	local terms=${2}
	local line_fmt=""

	if [ ${indent_lvl} -eq 1 ];
	then
		line_fmt="-+="
	elif [ ${indent_lvl} -eq 2 ];
	then
		line_fmt=" |-+="
	elif [ ${indent_lvl} -eq 3 ];
	then
		line_fmt=" | \---"
	else
		return 0
	fi;
	for t in ${terms[@]};
	do
		line_fmt="${line_fmt}  ${t}"
	done;
	echo "${line_fmt}"
}

function print_subnet_infos() {
	local subnet_id="${1}"
	local nat_gateways="${2}"
	local instances="${3}"

	local instance_names=($(filter_json "${instances}" ".Reservations[].Instances[] | select(.SubnetId == \"${subnet_id}\") | (.Tags[] | select(.Key == \"Name\") | .Value)"))
	local instance_privips=($(filter_json "${instances}" ".Reservations[].Instances[] | select(.SubnetId == \"${subnet_id}\") | .PrivateIpAddress"))
	local instance_ids=($(filter_json "${instances}" ".Reservations[].Instances[] | select(.SubnetId == \"${subnet_id}\") | .InstanceId"))
	local instance_states=($(filter_json "${instances}" ".Reservations[].Instances[] | select(.SubnetId == \"${subnet_id}\") | .State.Name"))
	local instance_amis=($(filter_json "${instances}" ".Reservations[].Instances[] | select(.SubnetId == \"${subnet_id}\") | .ImageId"))

	for instance_index in ${!instance_ids[@]};
	do
		echo "$(fmt_line 3 "${subnet_names[${instance_index}]} ${instance_privips[${instance_index}]} ${instance_ids[${instance_index}]} ${instance_states[${instance_index}]} ${instance_amis[${instance_index}]}")"
	done;
}

function print_vpc_infos() {
	local vpc_id=${1}
	local subnets="${2}"
	local nat_gateways="${3}"
	local instances="${4}"

	local subnet_names=($(filter_json "${subnets}" '.Subnets[].Tags[] | select(.Key == "Name") | .Value'))
	local subnet_cidr=($(filter_json "${subnets}" '.Subnets[].CidrBlock'))
	local subnet_ids=($(filter_json "${subnets}" '.Subnets[].SubnetId'))
	local subnet_states=($(filter_json "${subnets}" '.Subnets[].State'))
	local subnet_azs=($(filter_json "${subnets}" '.Subnets[].AvailabilityZone'))

	for subnet_index in ${!subnet_ids[@]};
	do
		echo "$(fmt_line 2 "${subnet_names[${subnet_index}]} ${subnet_cidr[${subnet_index}]} ${subnet_ids[${subnet_index}]} ${subnet_states[${subnet_index}]} ${subnet_azs[${subnet_index}]}")"
		print_subnet_infos ${subnet_ids[${subnet_index}]} "${nat_gateways}" "${instances}"
	done;
}

VPCS=$(describe_vpcs)

set -o nounset
vpc_names=($(filter_json "${VPCS}" '.Vpcs[].Tags[] | select(.Key == "Name") | .Value'))
vpc_cidrs=($(filter_json "${VPCS}" '.Vpcs[].CidrBlock'))
vpc_ids=($(filter_json "${VPCS}" '.Vpcs[].VpcId'))
vpc_states=($(filter_json "${VPCS}" '.Vpcs[].State'))

for vpc_index in ${!vpc_ids[@]};
do
	subnets=$(describe_vpc_resource_type ${vpc_ids[${vpc_index}]} "subnets")
	instances=$(describe_vpc_resource_type ${vpc_ids[${vpc_index}]} "instances")
  echo "${instances}"
	nat_gateways=$(describe_vpc_resource_type ${vpc_ids[${vpc_index}]} "nat-gateways")
	# Not filtering by subnet id cause it would slow down things

	echo $(fmt_line 1 "${vpc_names[${vpc_index}]} ${vpc_cidrs[${vpc_index}]} ${vpc_ids[${vpc_index}]} ${vpc_states[${vpc_index}]}")
	print_vpc_infos ${vpc_ids[${vpc_index}]} "${subnets}" "${nat_gateways}" "${instances}"
done;
