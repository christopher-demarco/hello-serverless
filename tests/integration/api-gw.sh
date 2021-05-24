#!/bin/bash

set -e

cd terraform
terragrunt init

URL=$(terraform output api-gw-url | sed -e 's/"//g')
OUT=$(curl -s $URL)
cd ..
if [[ $OUT == '"Hello, serverless!"' ]] ; then
    exit
else
    echo $OUT
    exit 1
fi
