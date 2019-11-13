#!/bin/bash
#d Delete users/clusters/contexts from kube config

#u ./clear_k8s_config.sh
set -o errexit

for i in $(kubectl config view | yaml2json  | jq -r '.users[].name');
do
  kubectl config unset users.${i}
done;

for i in $(kubectl config get-clusters);
do
  if [ ${i} != "NAME" ];
  then
    kubectl config delete-cluster ${i};
  fi;
done;

for i in $(kubectl config get-contexts | awk '{print $2}');
do
  if [ ${i} != "NAME" ];
  then
    kubectl config delete-context ${i};
  fi;
done;
