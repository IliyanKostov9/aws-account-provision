locals {
  table_name = "terraform-state-locks-aws"
}
resource "aws_dynamodb_table" "locks" {
  name         = local.table_name
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

import {
  to = aws_dynamodb_table.locks
  id = local.table_name
}
