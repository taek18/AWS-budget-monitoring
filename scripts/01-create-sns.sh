#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../00-env.sh"

SNS_TOPIC_ARN=$(aws sns create-topic \
    --name "$SNS_TOPIC_NAME" \
    --query TopicArn --output text)

echo "$SNS_TOPIC_ARN" > "${PROJECT_ROOT}/state/sns_topic_arn.txt"

echo "Created SNS topic: $SNS_TOPIC_ARN"
