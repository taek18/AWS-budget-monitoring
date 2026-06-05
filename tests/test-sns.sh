#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../00-env.sh"

SNS_TOPIC_ARN=$(cat "${PROJECT_ROOT}/state/sns_topic_arn.txt")

aws sns publish \
    --topic-arn "$SNS_TOPIC_ARN" \
    --message "Test message: Budget monitoring system is active for ${BUDGET_NAME}" \
    --subject "Budget Alert Test"

echo "Test notification sent to ${NOTIFICATION_EMAIL}"
