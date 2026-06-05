#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../00-env.sh"

aws budgets describe-budget \
    --account-id "$AWS_ACCOUNT_ID" \
    --budget-name "$BUDGET_NAME" \
    --query 'Budget.{Name:BudgetName,Limit:BudgetLimit,ActualSpend:CalculatedSpend.ActualSpend,ForecastedSpend:CalculatedSpend.ForecastedSpend}' \
    --output table

echo "Budget verification completed"
