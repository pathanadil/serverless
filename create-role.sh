#!/bin/sh


#This Script creates a Lambda role and attaches the policy required for it to run in a VPC

#import variables
. ./common-variables.sh
pwd 
#Setup Lambda Role
role_name=lambda-dynamo-data-api
#aws iam create-role --role-name ${role_name} \
  #  --assume-role-policy-document file://IAM/assume-role-lambda.json \
   # --profile $profile \
    #--region $region || true

sleep 1
#Add and Attach Policy to Lambda Role
dynamo_policy=dynamo-readonly-user-visits
dynamo_policy1=dynamo-readonly-user-visits1
aws iam create-policy --policy-name $dynamo_policy1 --policy-document file://IAM/$dynamo_policy.json --profile $profile || true

role_policy_arn="arn:aws:iam::$aws_account_id:policy/$dynamo_policy"
aws iam attach-role-policy \
    --role-name "${role_name}" \
    --policy-arn "${role_policy_arn}"  --profile ${profile} || true

#Add and Attach CloudWatch Policy to Lambda Role
cloudwatch_policy=lambda-cloud-write
aws iam create-policy --policy-name $cloudwatch_policy --policy-document file://IAM/$cloudwatch_policy.json --profile $profile || true

role_policy_arn="arn:aws:iam::$aws_account_id:policy/$cloudwatch_policy"
aws iam attach-role-policy \
    --role-name "${role_name}" \
    --policy-arn "${role_policy_arn}"  --profile ${profile} || true
    
#Add Policy for X-Ray
role_policy_arn="arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
aws iam attach-role-policy \
    --role-name "${role_name}" \
    --policy-arn "${role_policy_arn}"  \
    --profile ${profile} || true



