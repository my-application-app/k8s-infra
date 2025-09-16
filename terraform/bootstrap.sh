#!/bin/bash
set -e

# Variables
REGION=${AWS_REGION:-us-east-1}
BUCKET_NAME="aichatbotsamit-s3"
DYNAMODB_TABLE="aichatbot-terraform-locks"

# Check and create S3 bucket if it doesn't exist
if ! aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
  echo "Creating S3 bucket: $BUCKET_NAME"
  if [ "$REGION" = "us-east-1" ]; then
    aws s3api create-bucket --bucket "$BUCKET_NAME"
  else
    aws s3api create-bucket \
      --bucket "$BUCKET_NAME" \
      --region "$REGION" \
      --create-bucket-configuration LocationConstraint=$REGION
  fi
else
  echo "S3 bucket $BUCKET_NAME already exists"
fi

# Check and create DynamoDB table if it doesn't exist
if ! aws dynamodb describe-table --table-name "$DYNAMODB_TABLE" 2>/dev/null; then
  echo "Creating DynamoDB table: $DYNAMODB_TABLE"
  aws dynamodb create-table \
    --table-name "$DYNAMODB_TABLE" \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --region "$REGION"
else
  echo "DynamoDB table $DYNAMODB_TABLE already exists"
fi
