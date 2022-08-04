data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-*"]
  }
}

data "aws_iam_policy_document" "policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "app_role" {
  name               = "app_role"
  assume_role_policy = data.aws_iam_policy_document.policy.json
}

resource "aws_iam_role_policy_attachment" "attach_ssm" {
  role       = aws_iam_role.app_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "app_profile" {
  name = "app_profile"
  role = aws_iam_role.app_role.name
}


module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "ec2-${var.stage}-${var.owner}-test"

  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.nano"
  iam_instance_profile   = aws_iam_instance_profile.app_profile.name
  subnet_id              = var.subnets[0]
  vpc_security_group_ids = [aws_security_group.all.id]
  # key_name               = var.owner
}

// create aws_iam_instance_profile with the managed permission of "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"






# create security group allowing all
resource "aws_security_group" "all" {

  vpc_id = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



