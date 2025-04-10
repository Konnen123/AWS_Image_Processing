resource "aws_s3_bucket" "upload_image" {
  bucket = var.bucket_name
  force_destroy = true

  tags = {
    Name = var.bucket_name
    Environment = "Dev"
  }
}
resource "aws_s3_bucket" "processed_image_bucket" {
    bucket = "${var.bucket_name}-processed"
    force_destroy = true

    tags = {
        Name = "${var.bucket_name}-processed"
        Environment = "Dev"
    }
}
resource "aws_s3_bucket_notification" "bucket_notification"{
  bucket = aws_s3_bucket.upload_image.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.process_image_lambda.arn
    events = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}