#!/usr/bin/env bash
set -euo pipefail 
source "$(dirname "$0")/../00-env.sh"

SNS_TOPIC_ARN=$(cat "${PROJECT_ROOT}/state/sns_topic_arn.txt")

aws sns subscribe \
    --topic-arn "$SNS_TOPIC_ARN" \
    --protocol email \
    --notification-endpoint "$NOTIFICATION_EMAIL"

echo "Email subscription created. Check $NOTIFICATION_EMAIL for confirmation."

SUBSCRIPTION_ARN=$(aws sns list-subscriptions-by-topic \
    --topic-arn "$SNS_TOPIC_ARN" \
    --query 'Subscriptions[?Protocol==`email`].SubscriptionArn' \
    --output text)

echo "$SUBSCRIPTION_ARN" > "${PROJECT_ROOT}/state/subscription_arn.txt"

echo "Waiting for email confirmation..."
while true; do
    SUBSCRIPTION_ARN=$(aws sns list-subscriptions-by-topic \
        --topic-arn "$SNS_TOPIC_ARN" \
        --query 'Subscriptions[?Protocol==`email`].SubscriptionArn' \
        --output text)
    
    if [ "$SUBSCRIPTION_ARN" != "PendingConfirmation" ]; then
        echo "$SUBSCRIPTION_ARN" > "${PROJECT_ROOT}/state/subscription_arn.txt"
        echo "Subscription confirmed"
        break
    fi
    echo "Still pending... checking again in 10 seconds"
    sleep 10
done
