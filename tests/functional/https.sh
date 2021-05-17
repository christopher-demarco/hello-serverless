#!/bin/bash

set -e

cd ../../terraform
terraform init

URL=$(terraform output URL | sed -e 's/"//g')
OUT=$(curl -s $URL)
if [[ $OUT == '"Hello, serverless!"' ]] ; then
    /bin/true
else
    /bin/false
fi
