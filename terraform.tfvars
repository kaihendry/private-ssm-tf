# global
region  = "ap-southeast-1"
owner   = "hendry"
stage   = "dev"
project = "private-ssm"

# terraform cloud
tfc_organization  = webc
tfc_workspace_tag = cli

# network
security_groups = ["sg-751f423f"]
subnets         = ["subnet-039d69f30c554e650"]
# subnets         = ["subnet-fdf096a4"]
vpc_id = "vpc-f71cda91"
