# data "aws_iam_policy_document" "ecr_document"{
#     statement {
#       effect = "Allow"
#
#       actions = [
#           "ecr:BatchGetImage",
#           "ecr:GetDownloadUrlForLayer"
#         ]
#       resources = []
#     }
# }

data "aws_iam_policy_document" "ecr_document" {
  statement {
    sid    = "LambdaECRImageRetrievalPolicy"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = [
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]
  }
}

resource "aws_ecr_repository_policy" "ecr_policy" {
  policy     = data.aws_iam_policy_document.ecr_document.json
  repository = aws_ecr_repository.face_recognition_lambda_repository.name
}