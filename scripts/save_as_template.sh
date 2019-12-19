#!/bin/bash
#d Save current directory as template, a directory in ${TEMPLATES_PATH} will be created

#u save_as_template.sh template_name

#set -o errexit
set -o pipefail
#set -o nounset
#set -o xtrace

TEMPLATE_DIR=${TEMPLATES_PATH}/${1}
CURRENT_DIR=${PWD}

if [ ${1} = "" ];
then
  echo "Usage: save_as_template.sh template_name"
fi;

ls ${TEMPLATE_DIR} > /dev/null 2> /dev/null;

if [ ${?} -eq 0 ];
then
  while true;
  do
    read -p "Template directory ${1} already exists, replace ? [Yy/Nn]: " yn
    case ${yn} in
      [Yy]* ) rm -rf ${TEMPLATE_DIR}; break;;
      [Nn]* ) exit;;
      * ) echo "Yy/Nn";;
    esac
  done
fi;

mkdir ${TEMPLATE_DIR}

rsync --progress -auvz ${CURRENT_DIR}/* ${TEMPLATE_DIR}
