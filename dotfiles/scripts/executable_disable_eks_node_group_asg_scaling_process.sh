#!/bin/bash

set -o pipefail
set -o errexit
set -o nounset
# set -o verbose

if [ "${#}" -ne 3 ];
then
	echo "Usage: ${0} <eks-cluster-name> <eks-node-group-name> <feature-name>"
	echo "feature-name: Terminate|Launch|AddToLoadBalancer|AlarmNotification|AZRebalance|HealthCheck|ReplaceUnhealthy|ScheduledActions"
	exit 1
fi

function get_node_group_asg_name() {
	local cluster_name="${1}"
	local node_group_name="${2}"

	nodegroup=$(aws eks describe-nodegroup --cluster-name "${cluster_name}" --nodegroup-name "${node_group_name}")
	echo "${nodegroup}" | jq -r '.nodegroup.resources.autoScalingGroups[0].name'
}

function get_asg_suspended_processes() {
	local asg_name="${1}"

	asg=$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names "${asg_name}")
	echo "${asg}" | jq -r '.AutoScalingGroups[0].SuspendedProcesses[].ProcessName'
}

EKS_CLUSTER_NAME="${1}"
NODE_GROUP_NAME="${2}"
SCALING_PROCESS="${3}"

asg_name=$(get_node_group_asg_name "${EKS_CLUSTER_NAME}" "${NODE_GROUP_NAME}")
suspended_processes=$(get_asg_suspended_processes "${asg_name}")

set +o errexit
if grep "${SCALING_PROCESS}" <<< "${suspended_processes}" > /dev/null 2>&1;
then
	echo "ASG process ${SCALING_PROCESS} already suspended"
	exit 0
fi;
set -o errexit

echo "Suspending process ${SCALING_PROCESS} on ASG ${asg_name}"
aws autoscaling suspend-processes --auto-scaling-group-name "${asg_name}" --scaling-processes "${SCALING_PROCESS}"
suspended_processes=$(get_asg_suspended_processes "${asg_name}")
grep "${SCALING_PROCESS}" <<< "${suspended_processes}" > /dev/null 2>&1
echo "OK"
