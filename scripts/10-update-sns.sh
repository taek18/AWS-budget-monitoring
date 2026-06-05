#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../00-env.sh"

SNS_TOPIC_ARN=$(cat "${PROJECT_ROOT}/state/sns_topic_arn.txt")
LAMBDA_ARN=$(cat "${PROJECT_ROOT}/state/lambda_arn.txt")

aws lambda add-permission \
    --function-name "$LAMBDA_FUNCTION_NAME" \
    --statement-id "sns-invoke" \
    --action "lambda:InvokeFunction" \
    --principal "sns.amazonaws.com" \
    --source-arn "$SNS_TOPIC_ARN"

LAMBDA_SUBSCRIPTION_ARN=$(aws sns subscribe \
    --topic-arn "$SNS_TOPIC_ARN" \
    --protocol lambda \
    --notification-endpoint "$LAMBDA_ARN" \
    --query SubscriptionArn --output text)

echo "$LAMBDA_SUBSCRIPTION_ARN" > "${PROJECT_ROOT}/state/lambda_subscription_arn.txt"

echo "Lambda subscribed to SNS topic"
