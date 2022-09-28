#!/bin/bash

#d Start a container using docker run and map host groups & users

#u docker_run_map_user.sh [options] image ...

set -o errexit
set -o pipefail
set -o verbose
# set -o xtrace

UID=$(id -u)
GID=$(id -g)
docker run \
  --user "$UID:$GID" \
  --workdir="/home/$USER" \
  --volume="/etc/group:/etc/group:ro" \
  --volume="/etc/passwd:/etc/passwd:ro" \
  --volume="/etc/shadow:/etc/shadow:ro" \
  $@
