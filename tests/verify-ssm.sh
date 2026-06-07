#!/usr/bin/env bash
set -euo pipefail

if [ ! -f "${PROJECT_ROOT}/state/env.txt" ]; then
    echo " ! No deployment found. Run build.sh first."
    exit 1
fi

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
