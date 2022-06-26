# https://aws.amazon.com/premiumsupport/knowledge-center/ec2-systems-manager-vpc-endpoints/
# Create ssm, ec2messages & ssmmessages endpoints in subnet

resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"
  # enable dns
  private_dns_enabled = true

  # subnet_ids = var.subnets
}


resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true



  # subnet_ids = var.subnets
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true


  #subnet_ids = var.subnets
}


resource "aws_vpc_endpoint_subnet_association" "ssm_ssm_association" {
  vpc_endpoint_id = aws_vpc_endpoint.ssm.id
  subnet_id       = var.subnets[0]
}

resource "aws_vpc_endpoint_subnet_association" "ssm_ec2messages_association" {
  vpc_endpoint_id = aws_vpc_endpoint.ec2messages.id
  subnet_id       = var.subnets[0]
}


resource "aws_vpc_endpoint_subnet_association" "ssm_ssmmessages_association" {
  vpc_endpoint_id = aws_vpc_endpoint.ssmmessages.id
  subnet_id       = var.subnets[0]
}