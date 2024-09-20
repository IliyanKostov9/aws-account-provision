variable "iam_user" {
  description = "IAM user"
  type        = string
}

variable "iam_path" {
  description = "IAM path"
  type        = string
}

variable "tags" {
  description = "IAM tags"
  type        = map(string)
}
variable "iam_policy_actions" {
  description = "IAM policy actions"
  type        = list(string)
}

variable "iam_policy_resources" {
  description = "IAM resources"
  type        = list(string)
}
