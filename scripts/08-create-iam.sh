#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../00-env.sh"

# Trust policy
cat > "${PROJECT_ROOT}/config/trust-policy.json" << EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF

# Permissions policy
cat > "${PROJECT_ROOT}/config/lambda-policy.json" << EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ssm:GetParameter",
            "Resource": "arn:aws:ssm:${AWS_REGION}:${AWS_ACCOUNT_ID}:parameter${SSM_PARAMETER_NAME}"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:${AWS_REGION}:${AWS_ACCOUNT_ID}:*"
        }
    ]
}
EOF

# IAM role
LAMBDA_ROLE_ARN=$(aws iam create-role \
    --role-name "${LAMBDA_ROLE_NAME}" \
    --assume-role-policy-document "file://${PROJECT_ROOT}/config/trust-policy.json" \
    --query Role.Arn --output text)

# Attach permissions policy
aws iam put-role-policy \
    --role-name "${LAMBDA_ROLE_NAME}" \
    --policy-name "budget-alerts-lambda-policy" \
    --policy-document "file://${PROJECT_ROOT}/config/lambda-policy.json"

echo "$LAMBDA_ROLE_ARN" > "${PROJECT_ROOT}/state/lambda_role_arn.txt"

echo "IAM role created: $LAMBDA_ROLE_ARN"
