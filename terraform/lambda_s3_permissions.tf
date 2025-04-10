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

data "aws_iam_policy_document" "lambda_s3_permission_processed_image_bucket"{
    statement {
        effect = "Allow"

        actions = [
        "s3:PutObject",
        ]

        resources = [
        "${aws_s3_bucket.processed_image_bucket.arn}/*",
        ]
    }
}

resource "aws_iam_policy" "lambda_s3_iam_policy_processed_image_bucket" {
    name = "lambda_s3_iam_policy_processed_image_bucket"
    path = "/"
    description = "IAM policy for lambda to put objects on S3 bucket"
    policy = data.aws_iam_policy_document.lambda_s3_permission_processed_image_bucket.json
}

resource "aws_iam_role_policy_attachment" "lambda_s3_put_permission" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_s3_iam_policy_processed_image_bucket.arn
}