#!/bin/bash

set -o verbose
set -o pipefail
set -o errexit
set -o nounset

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

RSYNC_EXCLUDE_LIST_FILE=${RSYNC_EXCLUDE_LIST_FILE:-${SCRIPT_DIR}/rsync_exclude_list.txt}

rsync \
  -a \
  --progress \
  --exclude-from "${RSYNC_EXCLUDE_LIST_FILE}" \
  ${@}
