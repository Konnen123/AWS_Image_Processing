resource "aws_s3_bucket_lifecycle_configuration" "example" {
  bucket = aws_s3_bucket.upload_image.id

  rule {
    id = "expiration-rule"

    expiration {
      days = 1
    }

    status = "Enabled"
  }
}