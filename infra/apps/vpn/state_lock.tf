resource "aws_dynamodb_table" "locks" {
  name         = "terraform-state-locks-aws"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    env = var.env
  }
}
