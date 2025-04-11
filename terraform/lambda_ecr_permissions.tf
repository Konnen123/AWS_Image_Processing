data "aws_iam_policy_document" "lambda_ecr_document"{
  statement {
    effect = "Allow"

    actions = [
      "ecr:SetRepositoryPolicy",
      "ecr:GetRepositoryPolicy",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]

    resources = [
      aws_ecr_repository.face_recognition_lambda_repository.arn,
    ]
  }
}

resource "aws_iam_policy" "lambda_ecr_policy" {
  policy = data.aws_iam_policy_document.lambda_ecr_document.json
  path = "/"
}

resource "aws_iam_role_policy_attachment" "lambda_ecr_policy_attachment" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_ecr_policy.arn
}

output "err" {
  value = aws_ecr_repository.face_recognition_lambda_repository.arn
}