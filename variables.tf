variable "default_tags" {
  type        = map(string)
  description = "Map of default tags to apply to resources"
  default = {
    project = "ssm-test"
  }
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "owner" {
  type        = string
  description = "Owner of the project"
}

variable "project" {
  type        = string
  description = "Name of the project"
}

variable "stage" {
  type        = string
  description = "Stage to deploy to"
  default     = "dev"
}

variable "security_groups" {
}

variable "subnets" {
}

variable "vpc_id" {}