#!/usr/bin/env bash
set -uo pipefail
PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"

if [ ! -f "${PROJECT_ROOT}/state/env.txt" ]; then
    echo " ! state/env.txt not found, nothing to clean up"
    exit 0
fi

BUDGET_NAME=$(grep "^export BUDGET_NAME=" "${PROJECT_ROOT}/state/env.txt" | cut -d= -f2)
LAMBDA_FUNCTION_NAME=$(grep "^export LAMBDA_FUNCTION_NAME=" "${PROJECT_ROOT}/state/env.txt" | cut -d= -f2)
LAMBDA_ROLE_NAME=$(grep "^export LAMBDA_ROLE_NAME=" "${PROJECT_ROOT}/state/env.txt" | cut -d= -f2)
SSM_PARAMETER_NAME=$(grep "^export SSM_PARAMETER_NAME=" "${PROJECT_ROOT}/state/env.txt" | cut -d= -f2)
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Delete Budget
if aws budgets describe-budget --account-id "$AWS_ACCOUNT_ID" --budget-name "$BUDGET_NAME" &>/dev/null; then
    aws budgets delete-budget \
        --account-id "${AWS_ACCOUNT_ID}" \
        --budget-name "${BUDGET_NAME}"
    echo "Budget deleted: ${BUDGET_NAME}"
else
    echo " ! Budget not found, skipping"
fi

# Delete Lambda function
if [ ! -f "${PROJECT_ROOT}/state/lambda_arn.txt" ]; then
    echo " ! lambda_arn.txt not found, skipping"
else
    aws lambda delete-function \
        --function-name "$LAMBDA_FUNCTION_NAME"
    echo "Lambda function deleted: $LAMBDA_FUNCTION_NAME"
fi

# Delete IAM role policy and role
if aws iam get-role --role-name "$LAMBDA_ROLE_NAME" &>/dev/null; then
    aws iam delete-role-policy \
        --role-name "$LAMBDA_ROLE_NAME" \
        --policy-name "budget-alerts-lambda-policy"
    aws iam delete-role \
        --role-name "$LAMBDA_ROLE_NAME"
    echo "IAM role deleted: $LAMBDA_ROLE_NAME"
else
    echo " ! IAM role not found, skipping"
fi

# Delete SSM parameter
if [ ! -f "${PROJECT_ROOT}/state/ssm_parameter_name.txt" ]; then
    echo " ! SSM parameter not found, skipping"
else
    aws ssm delete-parameter \
        --name "$SSM_PARAMETER_NAME"
    echo "SSM parameter deleted: $SSM_PARAMETER_NAME"
fi

# Delete SNS topic
if [ ! -f "${PROJECT_ROOT}/state/sns_topic_arn.txt" ]; then
    echo " ! state/sns_topic_arn.txt not found, skipping"
else
    SNS_TOPIC_ARN=$(cat "${PROJECT_ROOT}/state/sns_topic_arn.txt")
    aws sns delete-topic \
        --topic-arn "$SNS_TOPIC_ARN"
    echo "SNS topic deleted"
fi

# Delete CloudWatch log group
aws logs delete-log-group \
    --log-group-name "/aws/lambda/${LAMBDA_FUNCTION_NAME}"

# Clean up local files
rm -f "${PROJECT_ROOT}/config"/*.json "${PROJECT_ROOT}/state"/*.txt "${PROJECT_ROOT}/lambda"/*.zip
unset BUDGET_NAME SNS_TOPIC_NAME NOTIFICATION_EMAIL
unset SNS_TOPIC_ARN SUBSCRIPTION_ARN RANDOM_SUFFIX
unset BUDGET_START BUDGET_START_EPOCH
unset LAMBDA_FUNCTION_NAME LAMBDA_ROLE_NAME LAMBDA_ARN
unset SSM_PARAMETER_NAME SLACK_WEBHOOK_URL
echo "Cleanup completed"
