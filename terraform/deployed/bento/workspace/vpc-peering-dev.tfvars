#define any tags appropriate to your environment
tags = {
  ManagedBy = "terraform"
  Project = "Bento"
  Environment = "dev"
}

#enter the region in which your aws resources will be provisioned
region = "us-west-1"

#specify your aws credential profile. Note this is not IAM role but rather profile configured during AWS CLI installation
profile = "icdc"

#specify the name you will like to call this project.
stack_name = "bento"

env = "dev"
