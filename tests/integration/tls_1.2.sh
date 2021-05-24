#!/bin/bash

set -e

fqdn="${TF_VAR_environment}.${TF_VAR_domain}"
api_gws=$(aws apigateway get-domain-names)
api_gw=$(echo $api_gws | jq ".items[] | select(.domainName == \"$fqdn\")")

if [[ $(echo $api_gw | jq -r '.securityPolicy') == "TLS_1_2" ]]; then
    exit
else
    echo $api_gw
    exit 1
fi



