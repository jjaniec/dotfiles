#!/bin/bash

set -o errexit
set -o pipefail
set -o verbose

dir_=${1:-./}

python -m pip install --target "${dir_}/package" -r "${dir_}/requirements.txt"
cd "${dir_}/package"
zip -r ../lambda-package.zip .
cd ../
zip -g ./lambda-package.zip ./*.py
