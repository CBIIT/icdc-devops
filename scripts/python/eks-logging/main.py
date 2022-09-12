import json
import boto3
from botocore.exceptions import ClientError
from os import getenv
import logging

logging.basicConfig(
    level=logging.INFO,
    format=f'%(asctime)s %(levelname)s %(message)s'
)
logger = logging.getLogger()
region_name = getenv("AWS_REGION")
eks_client = boto3.client("eks", region_name=region_name)


def list_all_eks_clusters():
    resp = eks_client.list_clusters()
    return resp.get("clusters")


def check_cluster_logging_status(cluster_name):
    resp = eks_client.describe_cluster(name=cluster_name)
    status = resp["cluster"]["logging"]["clusterLogging"][0]["enabled"]
    return status


def enable_cluster_logging(cluster_name):
    logging_config = {
        "clusterLogging": [
            {
                "types": [
                    "api",
                    "audit",
                    "authenticator",
                    "controllerManager",
                    "scheduler"
                ],
                "enabled": True
            }
        ]
    }
    try:
        resp = eks_client.update_cluster_config(name=cluster_name, logging=logging_config)
        return resp["update"]["status"]
    except ClientError as e:
        logger.error(e)
        return None


test_cluster = "basic-cluster"
logging_status = check_cluster_logging_status(cluster_name=test_cluster)
if not logging_status:
    update_logging = enable_cluster_logging(cluster_name=test_cluster)
    if update_logging == "Failed" or update_logging == "Cancelled":
        logger.error("error updating cluster")