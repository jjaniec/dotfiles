#!/bin/bash
#d Switch git user.email & user.name

#u git_switch_profile.sh [profile_name]

set -o errexit
#set -o nounset
set -o pipefail
#set -o xtrace

PROFILE_NAMES=(
  "github"
  "42"
)

DEFAULT_PROFILE_NAME="${PROFILE_NAMES[0]}"

GIT_NAME="Joffrey Janiec"

PROFILE_EMAILS=(
  "16088893+jjaniec@users.noreply.github.com"
  "jjaniec@student.42.fr"
)

if [ "${1}" != "" ];
then
  GIT_PROFILE_NAME=${1}
else
  GIT_PROFILE_NAME=${DEFAULT_PROFILE_NAME}
fi;

for i in "${!PROFILE_NAMES[@]}";
do
  if [[ "${PROFILE_NAMES[$i]}" = "${GIT_PROFILE_NAME}" ]];
  then
    GIT_NAME=${GIT_NAME}
    GIT_EMAIL=${PROFILE_EMAILS[${i}]}
  fi
done

if [ "${GIT_EMAIL}" = "" ];
then
  echo -e "No such profile: ${1}\nProfiles: ${PROFILE_NAMES[@]}"
  exit 1
fi;


git config --global --replace-all user.name "${GIT_NAME}"
git config --global --replace-all user.email "${GIT_EMAIL}"
git config --replace-all user.name "${GIT_NAME}"
git config --replace-all user.email "${GIT_EMAIL}"

echo "Switched git profile to '${GIT_NAME}' / '${GIT_EMAIL}'"
