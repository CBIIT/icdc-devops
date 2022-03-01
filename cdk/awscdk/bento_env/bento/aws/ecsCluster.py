import os
from aws_cdk import aws_ecs as ecs
from aws_cdk import aws_ec2 as ec2
from aws_cdk import aws_iam as iam
from aws_cdk import core as cdk

class ECSCluster:
  def createResources(self, ns):

    # ECS Cluster
    self.bentoECS = ecs.Cluster(self,
        "{}-ecs".format(ns),
        cluster_name="{}".format(ns),
        vpc=self.bentoVPC)
    
    self.bentoECS_ASG = self.bentoECS.add_capacity("{}-ecs-instance".format(ns),
        instance_type=ec2.InstanceType(os.environ.get('FRONTEND_INSTANCE_TYPE')),
        key_name=os.environ.get('SSH_KEY_NAME'),
        auto_scaling_group_name="{}-frontend".format(ns),
        task_drain_time=cdk.Duration.minutes(0),
        min_capacity=int(os.environ.get('MIN_SIZE')),
        max_capacity=int(os.environ.get('MAX_SIZE')))

    ecsPolicyDocument = {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": "ecs:*",
          "Resource": "*"
        },
        {
          "Effect": "Allow",
          "Action": "ecr:*",
          "Resource": "*"
        },
        {
          "Effect": "Allow",
          "Action": "ssm:*",
          "Resource": "*"
        },
        {
          "Effect": "Allow",
          "Action": "s3:*",
          "Resource": "*"
        }
      ]
    }

    clusterPolicy = iam.Policy(self,
        "{}-cluster-policy".format(ns),
        policy_name="{}-ecs-policy".format(ns),
        document=iam.PolicyDocument.from_json(ecsPolicyDocument))
    #cdk.Tags.of(ecsPolicy).add("Name", "{}-ecs-policy".format(ns)
    
    self.bentoECS_ASG.role.attach_inline_policy(clusterPolicy)
    self.bentoECS_ASG.role.add_managed_policy(iam.ManagedPolicy.from_aws_managed_policy_name('service-role/AmazonEC2ContainerServiceforEC2Role'))

    # User Data Script for ECS
    initFile = open("aws/scripts/ecs_init.sh")
    initScript = initFile.read()
    initFile.close()

    initScript = initScript.replace('CLUSTER_NAME', ns)
    initScript = initScript.replace('PROJECT', os.environ.get('PROJECT'))
    initScript = initScript.replace("ENV_NAME", os.environ.get('TIER'))

    self.bentoECS_ASG.add_user_data(initScript)