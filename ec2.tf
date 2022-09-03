resource "null_resource" "example" {}

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

  ami                  = data.aws_ami.amazon_linux.id
  instance_type        = "t3.nano"
  iam_instance_profile = aws_iam_instance_profile.app_profile.name
  subnet_id            = var.private_subnet_id
  # key_name               = var.owner
}
