locals{
  zip_file = "../lambdas/${var.lambda_name}.zip"
  handler_file = "../lambdas/${var.lambda_name}/handler.py"
}

resource "aws_lambda_function" "process_image_lambda" {
  function_name = var.lambda_name
  role          = aws_iam_role.iam_for_lambda.arn

  filename = local.zip_file
  handler = var.lambda_handler

  runtime = var.lambda_runtime
  timeout = var.lambda_timeout

  source_code_hash = base64sha256(filebase64(local.handler_file))
  environment {
    variables = {
      S3_PROCESSED_IMAGE_BUCKET = aws_s3_bucket.processed_image_bucket.bucket
    }
  }
  depends_on = [
    data.archive_file.python_lambda_package,
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.cloudwatch_log_group_lambda
  ]
}