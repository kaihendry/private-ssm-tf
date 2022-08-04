output "instance_id" {
  description = "ID of the EC2 instance"
  value       = module.ec2_instance.id
}

output "iam_instance_profile" {
  description = "IAM instance profile"
  value       = aws_iam_instance_profile.app_profile.name
}
