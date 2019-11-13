#!/bin/bash
#d Update kubeconfig to connect to an aws eks cluster

#u REGION='' ./eks_connect.sh cluster-name

set -o errexit
set -o nounset
set -o pipefail

REGION=${EKS_CLUSTER_REGION:=eu-west-1}
CLUSTER_NAME=${1}

aws sts get-caller-identity > /dev/null
aws eks --region ${REGION} update-kubeconfig --name ${CLUSTER_NAME}
kubectl get svc > /dev/null
