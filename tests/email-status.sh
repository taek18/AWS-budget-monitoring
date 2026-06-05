#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../00-env.sh"

SNS_TOPIC_ARN=$(cat "${PROJECT_ROOT}/state/sns_topic_arn.txt")

aws sns list-subscriptions-by-topic \
    --topic-arn "$SNS_TOPIC_ARN" \
    --query 'Subscriptions[?Protocol==`email`].{Email:Endpoint,Status:SubscriptionArn}' \
    --output table
    