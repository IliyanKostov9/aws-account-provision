variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "env" {
  description = "Environment dev/prod"
  type        = string
  default     = "dev"
}

variable "app_name" {
  description = "App name"
  type        = string
}

variable "ec2_name" {
  description = "Name of the passbolt ec2 instance"
  type        = string
}

variable "ec2_ami" {
  description = "AMI ID on Ireland"
  type        = string
}

variable "ec2_instance_type" {
  description = "The type of instance on EC2"
  type        = string
}
variable "ec2_tags" {
  description = "tags for the ec2 instance"
  type        = map(string)
}

variable "ec2_key_pair_name" {
  description = "EC2 key name"
  type        = string
}

variable "ec2_key_pair_public_key" {
  description = "EC2 public key"
  type        = string
}

variable "ec2_remote_exec_commands" {
  description = "Linux commands upon init"
  type        = list(string)
}

variable "sg_ingress_port" {
  description = "Security ingress port"
  type        = number
  default     = 80
}

variable "iam_user" {
  description = "IAM user"
  type        = string
}

variable "iam_path" {
  description = "IAM path"
  type        = string
  default     = "/"
}

variable "tags" {
  description = "IAM tags"
  type        = map(string)
  default = {
    "env" = "prod"
  }
}
variable "iam_policy_actions" {
  description = "IAM policy actions"
  type        = list(string)
}

variable "iam_policy_resources" {
  description = "IAM resources"
  type        = list(string)
}
