#!/usr/bin/env python3
import os, sys

from aws_cdk import core as cdk
from aws_cdk import core

from bento.bento_stack import BentoStack
from dotenv import load_dotenv

load_dotenv()

app = core.App()

# The stack name is set using values in the .env file
stackname = os.environ.get('PROJECT') + '-' + os.environ.get('TIER')
BentoStack(app, stackname,

  # The environment variables "AWS_DEFAULT_ACCOUNT", "AWS_DEFAULT_REGION" need to be set
  # These are not in the .env file by default but can be added
  env = core.Environment(account=os.environ["AWS_DEFAULT_ACCOUNT"], region=os.environ["AWS_DEFAULT_REGION"])

)

bentoTags = dict(s.split(':') for s in os.environ.get('TAGS').split(","))

for tag,value in bentoTags.items():
  core.Tags.of(app).add(tag, value)

app.synth()