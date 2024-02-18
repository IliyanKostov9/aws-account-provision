output "lambda_function_sendgrid" {
  value       = aws_lambda_function.test_lambda.arn
  description = "Lambda arn output to be referenced to other modules"

}
