#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../00-env.sh"

LAMBDA_ARN=$(cat "${PROJECT_ROOT}/state/lambda_arn.txt")

MOCK_EVENT='{
    "Records": [
        {
            "Sns": {
                "Subject": "Test Budget Alert",
                "Message": "This is a test notification from the budget monitoring system"
            }
        }
    ]
}'

aws lambda invoke \
    --function-name "$LAMBDA_FUNCTION_NAME" \
    --payload "$MOCK_EVENT"\
    --cli-binary-format raw-in-base64-out \
    "${PROJECT_ROOT}/state/response.json"

cat "${PROJECT_ROOT}/state/response.json"
rm "${PROJECT_ROOT}/state/response.json"

echo "Lambda test invocation completed - check Slack for message"
