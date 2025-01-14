#!/bin/bash
#d Pick aws profile defined in ~/.aws/config with fzf

#u aws_profile_picker.sh

# set -o verbose
set -o errexit
set -o pipefail

TEMP=$(mktemp)

PROFILE="$(cat ~/.aws/config | grep -E ']$' | cut -d ' ' -f 2 | tr -d '[]' | fzf)"
export AWS_PROFILE="${PROFILE}"

set +o errexit
aws sts get-caller-identity --query Arn > ${TEMP}
if [ $? -eq 1 ];
then
	echo "${PROFILE}" | grep -q "sso" 2>/dev/null
	if [ $? -eq 1 ];
        then
		aws sso login
		[ $? -eq 1 ] && (echo "failed"; exit 1)
	fi;
fi;
set -o errexit
ASSUMED_ARN=$(cat "${TEMP}" | tr -d '"')
echo "[STS] Now using: ${ASSUMED_ARN}"

set +o errexit
set +o pipefail

$SHELL
