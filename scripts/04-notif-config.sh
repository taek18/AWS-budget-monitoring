#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../00-env.sh"

SNS_TOPIC_ARN=$(cat state/sns_topic_arn.txt)

cat > "${PROJECT_ROOT}/config/notifications.json" << EOF
[
    {
        "Notification": {
            "ComparisonOperator": "GREATER_THAN",
            "NotificationType": "ACTUAL",
            "Threshold": 80,
            "ThresholdType": "PERCENTAGE"
        },
        "Subscribers": [
            {
                "Address": "${SNS_TOPIC_ARN}",
                "SubscriptionType": "SNS"
            }
        ]
    },
    {
        "Notification": {
            "ComparisonOperator": "GREATER_THAN",
            "NotificationType": "ACTUAL",
            "Threshold": 100,
            "ThresholdType": "PERCENTAGE"
        },
        "Subscribers": [
            {
                "Address": "${SNS_TOPIC_ARN}",
                "SubscriptionType": "SNS"
            }
        ]
    },
    {
        "Notification": {
            "ComparisonOperator": "GREATER_THAN",
            "NotificationType": "FORECASTED",
            "Threshold": 80,
            "ThresholdType": "PERCENTAGE"
        },
        "Subscribers": [
            {
                "Address": "${SNS_TOPIC_ARN}",
                "SubscriptionType": "SNS"
            }
        ]
    }
]
EOF

echo "Notification configuration created with thresholds: 80% actual, 100% actual, and 80% forecasted"
