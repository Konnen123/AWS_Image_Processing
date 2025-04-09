data "aws_iam_policy_document" "lambda_s3_permissions" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.upload_image.arn}/*",
    ]
  }
}

resource "aws_iam_policy" "lambda_s3_iam_policy" {
  name = "lambda_s3_iam_policy"
  path = "/"
  description = "IAM policy for lambda to access S3 bucket"
  policy = data.aws_iam_policy_document.lambda_s3_permissions.json
}

resource "aws_iam_role_policy_attachment" "lambda_s3_get_permission" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_s3_iam_policy.arn
}