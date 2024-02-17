region = "eu-west-1"
env    = "prod"

# Lambda configs
lambda_name = "prod-personal-sendgrid-lambda-aws"
#lambda_function_file_path = "src/lambda/SendGridMessage"
lambda_handler     = "index.py"
lambda_runtime     = "python3.11"
lambda_source_dir  = "../../../../src/lambda/SendGridMessage"
lambda_output_path = "lambda_deployment_package.zip"

# IAM configs
iam_role_lambda = "prod-personal-sendgrid-iam-aws"

lambda_env_variables = {
  "key" = "value"
}
tags = {
  "env"     = "dev"
  "type"    = "personal"
  "service" = "lambda"
  "app"     = "sendgrid"
}


