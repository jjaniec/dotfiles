#!/bin/bash
#d Build & push image from a dockerfile to dockerhub & update latest image
#u ./dockerhub_push_dockerfile.sh example.dockerfile user/repo:tag

set -o verbose
set -o nounset

repo=$(echo ${2} | cut -d ':' -f 1)

docker build -f ${1} -t ${2} .
docker tag ${2} ${repo}:latest
docker push ${2}
docker push ${repo}:latest
