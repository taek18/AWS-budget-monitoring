#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../00-env.sh"

LAMBDA_ROLE_ARN=$(cat "${PROJECT_ROOT}/state/lambda_role_arn.txt")

echo "Waiting for IAM role to propagate..."
sleep 10

zip -j "${PROJECT_ROOT}/lambda/budget_alert.zip" "${PROJECT_ROOT}/lambda/budget_alert.py"

LAMBDA_ARN=$(aws lambda create-function \
    --function-name "$LAMBDA_FUNCTION_NAME" \
    --runtime python3.12 \
    --role "$LAMBDA_ROLE_ARN" \
    --handler budget_alert.lambda_handler \
    --zip-file "fileb://${PROJECT_ROOT}/lambda/budget_alert.zip" \
    --environment "Variables={SSM_PARAMETER_NAME=${SSM_PARAMETER_NAME}}" \
    --query FunctionArn --output text)

echo "$LAMBDA_ARN" > "${PROJECT_ROOT}/state/lambda_arn.txt"

echo "Lambda function created: $LAMBDA_ARN"
