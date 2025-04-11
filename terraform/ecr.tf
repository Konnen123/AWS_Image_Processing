resource "aws_ecr_repository" "face_recognition_lambda_repository" {
  name                 = "face_recognition_lambda_repository"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true
}