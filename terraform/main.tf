resource "aws_lambda_function" "process_image_lambda" {
  function_name = var.lambda_name
  role          = aws_iam_role.iam_for_lambda.arn

  package_type = "Image"
  image_uri = "${aws_ecr_repository.face_recognition_lambda_repository.repository_url}:latest"

  timeout = var.lambda_timeout

  environment {
    variables = {
      S3_PROCESSED_IMAGE_BUCKET = aws_s3_bucket.processed_image_bucket.bucket
    }
  }
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.cloudwatch_log_group_lambda
  ]

}