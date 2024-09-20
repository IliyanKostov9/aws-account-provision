data "aws_iam_policy_document" "iam_policy" {
  statement {
    effect    = "Allow"
    actions   = var.iam_policy_actions
    resources = var.iam_policy_resources
  }
}
