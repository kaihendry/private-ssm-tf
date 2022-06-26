terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15.1"
    }
  }

  # https://app.terraform.io/app/webc/workspaces/cli/settings/general
  cloud {
    organization = "webc"

    workspaces {
      name = "cli"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = var.default_tags
  }
}

