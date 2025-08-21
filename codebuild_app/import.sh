#!/bin/bash

# Terraform import script for ShogiProject CodeBuild project and IAM resources

echo "Initializing Terraform..."
terraform init

echo "Importing IAM role..."
terraform import aws_iam_role.codebuild_service_role codebuild-build-sgp-app-service-role

echo "Note: Replace ACCOUNT_ID and REGION with actual values for your environment"
echo "Example account ID: 123456789012, Region: us-west-2"
echo ""
echo "Importing CodeBuild base policy..."
echo "terraform import aws_iam_policy.codebuild_base_policy arn:aws:iam::ACCOUNT_ID:policy/service-role/CodeBuildBasePolicy-PROJECT_NAME-REGION"

echo "Importing common exec SAM policy..."
echo "terraform import aws_iam_policy.common_exec_sam_policy arn:aws:iam::ACCOUNT_ID:policy/policy-sgp-app-exec-sam"

echo "Importing CodeConnections policy..."
echo "terraform import aws_iam_policy.codeconnections_policy arn:aws:iam::ACCOUNT_ID:policy/service-role/CodeBuildCodeConnectionsSourceCredentialsPolicy-PROJECT_NAME-REGION-ACCOUNT_ID"

echo "Importing policy attachments..."
echo "terraform import aws_iam_role_policy_attachment.codebuild_base_policy_attachment ROLE_NAME/arn:aws:iam::ACCOUNT_ID:policy/service-role/POLICY_NAME"
echo "terraform import aws_iam_role_policy_attachment.common_exec_sam_policy_attachment ROLE_NAME/arn:aws:iam::ACCOUNT_ID:policy/POLICY_NAME"
echo "terraform import aws_iam_role_policy_attachment.codeconnections_policy_attachment ROLE_NAME/arn:aws:iam::ACCOUNT_ID:policy/service-role/CODECONNECTIONS_POLICY_NAME"

echo "Importing CodeBuild project..."
terraform import aws_codebuild_project.sgp_app build-sgp-app

echo "Importing CodeBuild webhook..."
terraform import aws_codebuild_webhook.sgp_app build-sgp-app

echo "Import completed. Run 'terraform plan' to verify the configuration."