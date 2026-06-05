#!/usr/bin/env bash
set -e

export PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export AWS_REGION=$(aws configure get region)
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity \
    --query Account --output text)

export NOTIFICATION_EMAIL="your-email@example.com"

RANDOM_SUFFIX=$(aws secretsmanager get-random-password \
    --exclude-punctuation --exclude-uppercase \
    --password-length 6 --require-each-included-type \
    --output text --query RandomPassword)

mkdir -p "${PROJECT_ROOT}/state" "${PROJECT_ROOT}/config"

if [ -f "${PROJECT_ROOT}/state/env.txt" ]; then
	source ${PROJECT_ROOT}/state/env.txt
else
	export BUDGET_NAME="monthly-cost-budget-${RANDOM_SUFFIX}"
	export SNS_TOPIC_NAME="budget-alerts-${RANDOM_SUFFIX}"
	export SSM_PARAMETER_NAME="/budget-monitoring/slack-webhook-${RANDOM_SUFFIX}"
	export LAMBDA_ROLE_NAME="budget-alerts-lambda-role-${RANDOM_SUFFIX}"
	export LAMBDA_FUNCTION_NAME="budget-alerts-lambda-${RANDOM_SUFFIX}"
	echo "export BUDGET_NAME=${BUDGET_NAME}" > ${PROJECT_ROOT}/state/env.txt
	echo "export SNS_TOPIC_NAME=${SNS_TOPIC_NAME}" >> ${PROJECT_ROOT}/state/env.txt
	echo "export SSM_PARAMETER_NAME=${SSM_PARAMETER_NAME}" >> ${PROJECT_ROOT}/state/env.txt
	echo "export LAMBDA_ROLE_NAME=${LAMBDA_ROLE_NAME}" >> ${PROJECT_ROOT}/state/env.txt
	echo "export LAMBDA_FUNCTION_NAME=${LAMBDA_FUNCTION_NAME}" >> ${PROJECT_ROOT}/state/env.txt
	
	echo "Environment configured with budget name: ${BUDGET_NAME}"
fi
