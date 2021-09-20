#!/bin/bash

#d Connect docker cli to ecr repository of current aws account

#u ./aws_ecr_connect.sh

# set -o errexit
set -o pipefail
set -o nounset

function  get_account_id() {
  IDENTITY=$(aws sts get-caller-identity)

  echo "${IDENTITY}" | jq -r '.Account'
}

ACCOUNT_ID="${1:-$(get_account_id)}"
REGION="${2:-$(aws configure get region)}"

aws ecr get-login-password --region "${REGION}" | docker login --username AWS --password-stdin "${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com"

set +o nounset

if [ -z "${PURE_PROMPT_SYMBOL}" ];
then
  PURE_PROMPT_SYMBOL="❯"
fi;

export PURE_PROMPT_SYMBOL='%f%F{green}'"(OCIRepo: aws:${REGION}:${ACCOUNT_ID})"'%f %F{magenta}'"${PURE_PROMPT_SYMBOL}"
