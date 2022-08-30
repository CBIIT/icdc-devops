import boto3
import logging

#create custom session
aws_session = boto3.session.Session()
aws_region = aws_session.region_name
ec2_resource = boto3.resource('ec2', region_name=aws_region)

# create filter for instances in running state
running_instances = [
    {
        'Name': 'instance-state-name',
        'Values': ['running']
    }
]

#schedule tags
schedule_tag = [
    {
        'Key': 'Schedule',
        'Value': "office-hours-7-pm"
    }
]

#check running instances
def check_schedule_tag(instance):
    return [tag for tag in instance.tags if tag["Key"] == "Schedule"]


def tag_instances(instances: list, tag):
    if len(instances) > 0:
        for instance in instances:
            logging.info(f"Tagging instance {instance.id}")
            instance.create_tags(Tags=tag)

def handler(event,context):
    
    #filter running instances
    instances = ec2_resource.instances.filter(
        Filters=running_instances
    )

    instances_without_schedule_tag = [instance for instance in instances if len(check_schedule_tag(instance)) == 0]
    tag_instances(instances_without_schedule_tag,schedule_tag)
    logging.info("Tagging is complete")
