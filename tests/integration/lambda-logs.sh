#!/bin/bash

set -e

attached_policies=$(aws iam list-attached-role-policies --role-name  hello-${TF_VAR_environment}-lambda)
log_policy=$(echo $attached_policies | jq ".AttachedPolicies[] | select(.PolicyName == \"hello-${TF_VAR_environment}-logs\")")
policy_arn=$(echo $log_policy | jq -r .PolicyArn)

policy_versions=$(aws iam list-policy-versions --policy-arn $policy_arn)
default_version=$(echo $policy_versions | jq -r ".Versions[] | select(.IsDefaultVersion == true).VersionId")

policy=$(aws iam get-policy-version --policy-arn $policy_arn --version-id $default_version)
statement=$(echo $policy | jq ".PolicyVersion.Document.Statement[] | select(.Resource == \"arn:aws:logs:*:*:*\")")

# this is an inefficient use of jq
if [[ $(echo $statement | jq -e '.Action | any(. == "logs:CreateLogGroup")') == 'false' ]]; then
    echo $policy | jq .
    exit 1
fi
if [[ $(echo $statement | jq -e '.Action | any(. == "logs:CreateLogStream")') == 'false' ]]; then
    echo $policy | jq .
    
    exit 1
fi
if [[ $(echo $statement | jq -e '.Action | any(. == "logs:PutLogEvents")') == 'false' ]]; then
    echo $policy | jq .
    exit 1
fi
