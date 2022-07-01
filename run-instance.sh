#!/bin/bash

# image with ssm
# aws ssm get-parameters --names /aws/service/ecs/optimized-ami/amazon-linux-2/recommended
image_id=ami-0ba076ee2477bbf3c

aws ec2 run-instances --image-id $image_id \
--instance-type t3.nano \
--security-group-ids $(terraform output -raw security_group_id) \
--subnet-id $(terraform output -raw subnet_id) \
--iam-instance-profile Name=$(terraform output -raw iam_instance_profile) \
--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=ssm-port-forward}]'
