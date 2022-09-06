import boto3
from os import getenv

#retrieve region information from environment
aws_region = getenv("AWS_REGION")

#create sns clint
client = boto3.client("sns",region_name=aws_region)
#retrieve account id from session
aws_account_id = boto3.client("sts").get_caller_identity()["Account"]

def get_topic_subscription_arns(topic_arn):
    resp = client.list_subscriptions_by_topic(TopicArn=topic_arn)
    subscription_arns = [arn["SubscriptionArn"] for arn in  resp["Subscriptions"]]
    return subscription_arns

def get_subscription_status(topic_arn):
    subscription_status = []
    subscription_arns = get_topic_subscription_arns(topic_arn)
    for subscription_arn in subscription_arns:
        resp = client.get_subscription_attributes(SubscriptionArn=subscription_arn)
        if resp["Attributes"]["PendingConfirmation"] and resp["Attributes"]["PendingConfirmation"] == "true":
            status = {
                "account": resp["Attributes"]["Owner"],
                "status" : resp["Attributes"]["PendingConfirmation"]
            }
            subscription_status.append(status)

    return subscription_status


def handler(event,context):
    phd_topic_arn = f"arn:aws:sns:{aws_region}:{aws_account_id}:seronet-test-notifications-success"
    sns_subscription_statu = get_subscription_status(phd_topic_arn)
    




