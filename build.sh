#!/usr/bin/env bash
set -euo pipefail

source 00-env.sh
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