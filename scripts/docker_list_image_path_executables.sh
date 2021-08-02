#!/bin/bash

#d List all executables in a container default path

#u ./docker_list_image_path_executables.sh image

set -o nounset
set -o pipefail
set -o errexit

IMAGE="${1}"

docker run \
  -it \
  --entrypoint sh \
  "${IMAGE}" \
  -c 'IFS="${IFS}:"; for i in $(echo ${PATH} | cut -d ':' -f 1-); do find "${i}" -executable -type f; done;'
