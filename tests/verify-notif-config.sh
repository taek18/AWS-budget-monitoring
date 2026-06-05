#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../00-env.sh"

aws budgets describe-notifications-for-budget \
    --account-id "${AWS_ACCOUNT_ID}" \
    --budget-name "${BUDGET_NAME}"
    