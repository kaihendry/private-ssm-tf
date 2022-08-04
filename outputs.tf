output "instance_id" {
  description = "ID of the EC2 instance"
  value       = module.ec2_instance.id
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.all.id
}

output "subnet_id" {
  description = "ID of the subnet"
  value       = var.subnets[0]
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = var.vpc_id
}

output "iam_instance_profile" {
  description = "IAM instance profile"
  value       = aws_iam_instance_profile.app_profile.name
}