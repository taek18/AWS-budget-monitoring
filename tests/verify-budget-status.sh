#!/usr/bin/env bash
set -euo pipefail

if [ ! -f "${PROJECT_ROOT}/state/env.txt" ]; then
    echo " ! No deployment found. Run build.sh first."
    exit 1
fi

source "$(dirname "$0")/../00-env.sh"

aws budgets describe-budget \
    --account-id "${AWS_ACCOUNT_ID}" \
    --budget-name "${BUDGET_NAME}"
    