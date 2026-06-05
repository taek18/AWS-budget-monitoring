#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../00-env.sh"

aws budgets create-budget \
    --account-id "$AWS_ACCOUNT_ID" \
    --budget "file://${PROJECT_ROOT}/config/budget.json" \
    --notifications-with-subscribers "file://${PROJECT_ROOT}/config/notifications.json"

echo "Budget created successfully: $BUDGET_NAME"
