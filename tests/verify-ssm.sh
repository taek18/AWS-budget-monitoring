#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../00-env.sh"

aws ssm get-parameter \
    --name "$SSM_PARAMETER_NAME" \
    --query '{
        Name: Parameter.Name,
        Type: Parameter.Type,
        LastModified: Parameter.LastModifiedDate,
        Version: Parameter.Version
    }' \
    --output table
