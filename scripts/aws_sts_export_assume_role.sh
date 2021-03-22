#!/bin/bash

set -o pipefail
#set -o errexit

ROLE_ARN=${1}

temp_role=$(aws sts assume-role \
  --role-arn ${ROLE_ARN} \
  --role-session-name "$(cat /dev/random | head -c 5 | base64 | base64)" \
)

if [ $? -eq 0 ];
then
  echo "OK"

  unset AWS_PROFILE

  export AWS_ACCESS_KEY_ID=$(echo $temp_role | jq -r .Credentials.AccessKeyId)
  export AWS_SECRET_ACCESS_KEY=$(echo $temp_role | jq -r .Credentials.SecretAccessKey)
  export AWS_SESSION_TOKEN=$(echo $temp_role | jq -r .Credentials.SessionToken)

  ASSUMED_ROLE_ARN=$(aws sts get-caller-identity | jq -r '.Arn')

  export PURE_PROMPT_SYMBOL='%f%F{green}'"(${ASSUMED_ROLE_ARN})"'%f %F{magenta}❯'
fi;
