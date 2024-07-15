#!/bin/bash
#d Pick aws profile defined in ~/.aws/config with fzf

#u aws_profile_picker.sh

set -o errexit
set -o pipefail

export AWS_PROFILE="$(cat ~/.aws/config | grep -E ']$' | cut -d ' ' -f 2 | tr -d '[]' | fzf)"
ASSUMED_ARN=$(aws sts get-caller-identity --query Arn | tr -d '"')
echo "[STS] Now using: ${ASSUMED_ARN}"

set +o errexit
set +o pipefail
