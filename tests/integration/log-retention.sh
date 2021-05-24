#!/bin/bash

set -e

log_group_name="/aws/lambda/hello-${TF_VAR_environment}"
log_group_config=$(aws logs describe-log-groups | jq ".logGroups[] | select(.logGroupName == \"$log_group_name\")")
if [[ $(echo $log_group_config | jq -r .retentionInDays) == 7 ]]; then
       exit
else
	echo $log_group_config | jq .
	exit 1
 fi
