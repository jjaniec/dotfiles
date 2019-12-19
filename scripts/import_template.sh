#!/bin/bash
#d Import files from template in ${TEMPLATES_PATH} to current working directory

#u import_template.sh template_name

#set -o errexit
set -o pipefail
#set -o nounset
#set -o xtrace

if [ "${TEMPLATES_PATH}" = "" ];
then
  echo '${TEMPLATES_PATH} not defined, exiting'
  exit 1
fi;

TEMPLATE_NAME=${1}
TEMPLATE_DIR=${TEMPLATES_PATH}/${TEMPLATE_NAME}

function print_template_list()
{
  for i in $(ls -A1 ${TEMPLATES_PATH});
  do
    echo -e "\t${i}"
  done;
}

if [ "${TEMPLATE_NAME}" = "" ];
then
  echo "No template argument specified, usage:"
  echo -e "\timport_template.sh template_name"
  echo
  echo "Current list:"
  print_template_list
  exit 1
fi;

if ! ls ${TEMPLATE_DIR} > /dev/null 2> /dev/null;
then
  echo "No such template, current list:"
  print_template_list
  exit 1
fi;

rsync --progress -auvz ${TEMPLATE_DIR}/* .
