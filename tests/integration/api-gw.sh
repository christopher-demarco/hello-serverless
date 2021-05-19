#!/bin/bash

set -e

cd terraform
terraform init

URL=$(terraform output api-gw-url | sed -e 's/"//g')
OUT=$(curl -s $URL)
cd ..
if [[ $OUT == '"Hello, serverless!"' ]] ; then
    /bin/true
else
    /bin/false
fi
