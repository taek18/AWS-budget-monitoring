#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../00-env.sh"

# GNU date only
BUDGET_START=$(date -d "$(date +%Y-%m-01)" --iso-8601)
BUDGET_START_EPOCH=$(date -d "${BUDGET_START}" +%s) 

cat > "${PROJECT_ROOT}/config/budget.json" << EOF
{
    "BudgetName": "${BUDGET_NAME}",
    "BudgetLimit": {
        "Amount": "100",
        "Unit": "USD"
    },
    "BudgetType": "COST",
    "TimeUnit": "MONTHLY",
    "TimePeriod": {
        "Start": ${BUDGET_START_EPOCH},
        "End": 3706473600 
    },
    "CostTypes": {
        "IncludeCredit": true,
        "IncludeDiscount": true,
        "IncludeOtherSubscription": true,
        "IncludeRecurring": true,
        "IncludeRefund": true,
        "IncludeSubscription": true,
        "IncludeSupport": true,
        "IncludeTax": true,
        "IncludeUpfront": true,
        "UseBlended": false
    }
}
EOF

echo "Budget configuration created with \$100 monthly limit"
