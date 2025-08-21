#!/bin/bash

# Terraform import script for ShogiProject DynamoDB table

echo "Initializing Terraform..."
terraform init

echo "Importing DynamoDB table..."
terraform import aws_dynamodb_table.sgp_main table-sgp-pro-main

echo "Import completed. Run 'terraform plan' to verify the configuration."