import os
import json
import boto3
import urllib.request

def lambda_handler(event, context):
    ssm = boto3.client('ssm')
    parameter = ssm.get_parameter(
        Name=os.environ['SSM_PARAMETER_NAME'],
        WithDecryption=True
    )
    webhook_url = parameter['Parameter']['Value']

    sns_message = event['Records'][0]['Sns']['Message']
    subject = event['Records'][0]['Sns']['Subject']

    slack_message = {
        "text": f"*{subject}*\n{sns_message}"
    }

    request = urllib.request.Request(
        webhook_url,
        data=json.dumps(slack_message).encode('utf-8'),
        headers={'Content-Type': 'application/json'},
        method='POST'
    )
    urllib.request.urlopen(request)

    return {
        'statusCode': 200,
        'body': 'Notification sent'
    }