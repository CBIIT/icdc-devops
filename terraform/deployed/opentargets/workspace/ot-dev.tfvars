tags = {
  ManagedBy = "terraform"
  Project = "OpenTargets"
  Environment = "dev"
  Region = "us-east-1"
  ShutdownInstance = "Yes"
  POC = "Yizhen Chen"
}
#enter the region in which your aws resources will be provisioned
region = "us-east-1"

app = "opentargets"
domain_name = "bento-tools.org"
env = "dev"

ssh_user = "bento"

remote_state_bucket_name = "bento-terraform-remote-state"
#specify your aws credential profile. Note this is not IAM role but rather profile configured during AWS CLI installation
profile = "NCI_sow"

#specify the name you will like to call this project.
stack_name = "ot"

instance_type =  "t3.medium"

ssh_key_name = "devops"

#cutomize the volume size for all the instances created except database
instance_volume_size = 40