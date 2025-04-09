locals{
  app_jar_file = "../lambdas/${var.lambda_name}/target/${var.lambda_name}-${var.lambda_app_version}.jar"
}

resource "aws_lambda_function" "process_image_lambda" {
  function_name = var.lambda_name
  role          = aws_iam_role.iam_for_lambda.arn

  filename = local.app_jar_file
  handler = var.lambda_handler

  runtime = var.lambda_runtime
  timeout = var.lambda_timeout

  depends_on = [
    null_resource.build_jar,
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.cloudwatch_log_group_lambda
  ]
}