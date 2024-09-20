resource "aws_iam_user" "iam_user" {
  name = var.iam_user
  path = var.iam_path

  tags = var.tags
}

resource "aws_iam_access_key" "creds" {
  user = aws_iam_user.iam_user.name
}

resource "aws_iam_user_policy" "iam_user_policy" {
  name   = "${var.iam_user}-user-policy"
  user   = aws_iam_user.iam_user.name
  policy = data.aws_iam_policy_document.iam_policy.json
}
