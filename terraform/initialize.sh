#!/bin/bash

# Fetch values from SSM Parameter Store
bucket_name=$(aws ssm get-parameter --name "/resume_website/prod/s3/bucket_name" --query "Parameter.Value" --output text)
dynamodb_table_name=$(aws ssm get-parameter --name "/resume_website/prod/dynamodb/backend_table" --query "Parameter.Value" --output text)

# Write the values to the backend configuration file
cat > backend.hcl <<EOL
bucket         = "$bucket_name"
key            = "resume-front-end/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "$dynamodb_table_name"
encrypt        = true
EOL

# Initialize Terraform with the partial configuration file
terraform init -backend-config=backend.hcl
