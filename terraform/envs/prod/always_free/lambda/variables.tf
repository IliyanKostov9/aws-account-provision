variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"

}

variable "env" {
  description = "Project environment"
  type        = string
}


variable "lambda_name" {
  description = "Lambda function name"
  type        = string

}

variable "lambda_description" {
  description = "Lambda description"
  type        = string
  default     = "Deployed by Terraform"

}

variable "tags" {
  description = "tags for the ec2 instance"
  type        = map(string)

}

variable "lambda_handler" {
  description = "Lambda function handler name"
  type        = string

}

variable "lambda_runtime" {
  description = "Lambda function runtime"
  type        = string
  default     = "python3.11"

}

variable "lambda_source_dir" {
  description = "Source code of the lambda function"
  type        = string

}

variable "lambda_output_path" {
  description = "The deployment package of the lambda"
  type        = string

}

variable "lambda_env_variables" {
  description = "Environment variables for lambda"
  type        = map(string)

  default = {
    key = ""
  }

}

variable "lambda_memory_size" {
  description = "Memory size of the lambda"
  type        = number
  default     = 512

}


variable "iam_role_lambda" {
  description = "IAM role for the lambda function"
  type        = string

}
