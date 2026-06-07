#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "Checking for leftover resources..."

if [ -f "${PROJECT_ROOT}/state/env.txt" ]; then
    echo " ! state/env.txt exists - deployment may be active"
    cat "${PROJECT_ROOT}/state/env.txt"
fi

aws budgets describe-budgets \
    --account-id "$(aws sts get-caller-identity --query Account --output text)" \
    --query 'Budgets[?contains(BudgetName, `monthly-cost-budget`)].BudgetName' \
    --output table

aws sns list-topics \
    --query 'Topics[*].TopicArn' \
    --output table

aws lambda list-functions \
    --query 'Functions[?contains(FunctionName, `budget-alerts`)].FunctionName' \
    --output table

aws iam list-roles \
    --query 'Roles[?contains(RoleName, `budget-alerts`)].RoleName' \
    --output table

aws ssm describe-parameters \
    --query 'Parameters[?contains(Name, `budget-monitoring`)].Name' \
    --output table