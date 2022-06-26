module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "ec2-${var.stage}-${var.owner}-test"

  ami                    = "ami-0c802847a7dd848c0"
  instance_type          = "t3.nano"
  	iam_instance_profile = aws_iam_instance_profile.session_manager.name
  subnet_id              = var.subnets[0]
  vpc_security_group_ids = [aws_security_group.all.id]
  key_name               = var.owner

}

# create security group allowing all
resource "aws_security_group" "all" {

  vpc_id = var.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-getting-started-instance-profile.html

resource "aws_iam_policy" "session_manager" {
  name        = "session_manager"
  path        = "/"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssm:UpdateInstanceInformation",
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetEncryptionConfiguration"
            ],
            "Resource": "*"
        }
    ]
  })
}

data "aws_iam_policy_document" "session_manager" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "session_manager" {
  assume_role_policy = data.aws_iam_policy_document.session_manager.json
  name               = "DevSresSessionManager"
}

resource "aws_iam_role_policy_attachment" "session_manager" {
  role       = aws_iam_role.session_manager.name
  policy_arn = aws_iam_policy.session_manager.arn
}

resource "aws_iam_instance_profile" "session_manager" {
  name = "session_manager"
  role = aws_iam_role.session_manager.name
}

output session_manager_role {
  value = aws_iam_role.session_manager.arn
}


