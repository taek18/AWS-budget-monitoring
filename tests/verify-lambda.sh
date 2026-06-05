#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../00-env.sh"

aws lambda get-function-configuration \
    --function-name "$LAMBDA_FUNCTION_NAME" \
    --query '{
        Name: FunctionName,
        Runtime: Runtime,
        Role: Role,
        Handler: Handler,
        State: State,
        Environment: Environment.Variables
    }' \
    --output table
