#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/00-env.sh"

if [ -f "${PROJECT_ROOT}/state/env.txt" ]; then
    echo " ! state/env.txt already exists - a deployment may already be active"
    echo " ! Run cleanup.sh first or check status with tests/status.sh"
    read -rp "Continue anyway? (y/N): " CONFIRM
    if [ "$CONFIRM" != "y" ]; then
        echo "Aborting"
        exit 0
    fi
fi

./scripts/01-create-sns.sh
./scripts/02-subscribe-sns.sh
./scripts/03-budget-config.sh
./scripts/04-notif-config.sh
./scripts/05-build-budget.sh
./scripts/06-verify-budget.sh
./scripts/07-ssm-webhook.sh
./scripts/08-create-iam.sh
./scripts/09-create-lambda.sh
./scripts/10-update-sns.sh