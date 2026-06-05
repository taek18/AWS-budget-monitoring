#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../00-env.sh"

read -rsp "Enter Slack webhook URL: " SLACK_WEBHOOK_URL
echo

aws ssm put-parameter \
    --name "$SSM_PARAMETER_NAME" \
    --value "$SLACK_WEBHOOK_URL" \
    --type SecureString \
    --overwrite

echo "Webhook URL stored in Parameter Store: $SSM_PARAMETER_NAME"
