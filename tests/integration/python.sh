#!/bin/bash

set -e

lambda_name="hello-${TF_VAR_environment}"
lambda_config=$(aws lambda get-function --function-name $lambda_name)

if [[ $(echo $lambda_config | jq -r .Configuration.Runtime) == "python3.6" ]]; then
    exit
else
    echo $lambda_config | jq .
    exit 1
fi
