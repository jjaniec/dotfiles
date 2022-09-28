#!/bin/bash
#d Run a command on specified ssh target or default one

#u ssh_exec.sh profile_name [command]

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

DEFAULT_SSH_CMD=bash

if [ "${#}" -lt 2 ];
then
  SSH_CMD=${DEFAULT_SSH_CMD}
else
  SSH_CMD=$(echo ${@} | cut -d ' ' -f 2-)
fi;

PROFILE_NAMES=(
  profile_1
)

PROFILE_USERS=(
  ec2-user
)

PROFILE_IPS=(
  "1.2.3.4"
)

PROFILE_PORTS=(
  22
)

PROFILE_KEYPAIRS=(
  "~/Downloads/default_kp.pem"
)

SSH_PROFILE_NAME=${1:=${PROFILE_NAMES[0]}}
for i in "${!PROFILE_NAMES[@]}"; do
  if [[ "${PROFILE_NAMES[$i]}" = "${SSH_PROFILE_NAME}" ]]; then
    profile_idx=${i}
  fi
done

SSH_USER=${PROFILE_USERS[${profile_idx}]}
SSH_PORT=${PROFILE_PORTS[${profile_idx}]}
SSH_KEYPAIR=${PROFILE_KEYPAIRS[${profile_idx}]}
SSH_HOST=${PROFILE_IPS[${profile_idx}]}

SSH_OPTS="-t -q -p ${SSH_PORT}"

if [ "${SSH_KEYPAIR}" != "" ];
then
  SSH_OPTS="${SSH_OPTS} -i ${SSH_KEYPAIR}"
fi;

ssh ${SSH_OPTS} ${SSH_USER}@${SSH_HOST} ${SSH_CMD}
