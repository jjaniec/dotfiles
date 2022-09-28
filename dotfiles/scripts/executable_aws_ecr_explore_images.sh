#!/bin/bash

#d Fetch tagged images of an aws ecr repository

#u ./aws_ecr_explore_images.sh

set -o errexit
set -o pipefail
set -o nounset

REPOSITORY=$(aws ecr describe-repositories  | jq -r '.repositories[].repositoryUri' | sort | fzf)
REPOSITORY_NAME="$(echo ${REPOSITORY} | cut -d '/' -f 2-)"

IMAGES=$(aws ecr list-images --repository-name "${REPOSITORY_NAME}" --filter 'tagStatus=TAGGED')
TAGS=($(echo "${IMAGES}" | jq -r '.imageIds[].imageTag'))
DIGESTS=($(echo "${IMAGES}" | jq -r '.imageIds[].imageDigest'))

IFS="${IFS}$(echo)"
for i in ${!TAGS[@]};
do
	echo "${DIGESTS[$i]} ${REPOSITORY}:${TAGS[$i]}"
done;
