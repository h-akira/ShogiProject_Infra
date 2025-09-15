#!/bin/bash

# Import existing Cognito resources into Terraform state
# This script should be run after terraform init and before terraform plan

set -e

# Check if terraform.tfvars exists
if [ ! -f "terraform.tfvars" ]; then
    echo "Error: terraform.tfvars not found. Please copy from terraform.tfvars.sample and configure."
    exit 1
fi

# Get values from terraform.tfvars
USER_POOL_ID=$(grep "user_pool_id" terraform.tfvars | cut -d'"' -f2)
USER_POOL_CLIENT_ID=$(grep "user_pool_client_id" terraform.tfvars | cut -d'"' -f2)

if [ -z "$USER_POOL_ID" ] || [ -z "$USER_POOL_CLIENT_ID" ]; then
    echo "Error: user_pool_id and user_pool_client_id must be set in terraform.tfvars"
    exit 1
fi

echo "Importing Cognito User Pool: $USER_POOL_ID"
terraform import aws_cognito_user_pool.main "$USER_POOL_ID" || echo "User Pool might already be imported"

echo "Importing Cognito User Pool Client: $USER_POOL_CLIENT_ID"
terraform import aws_cognito_user_pool_client.main "$USER_POOL_ID/$USER_POOL_CLIENT_ID" || echo "User Pool Client might already be imported"

echo "Importing Cognito User Pool Domain: ap-northeast-15ayjqyrc8"
terraform import aws_cognito_user_pool_domain.main "ap-northeast-15ayjqyrc8" || echo "User Pool Domain might already be imported"

echo "Import completed. You can now run 'terraform plan' to see the current state."