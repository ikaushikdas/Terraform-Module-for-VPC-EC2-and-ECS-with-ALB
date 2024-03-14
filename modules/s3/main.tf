provider "aws" {
  region = var.region
}

# Create an S3 bucket for Terraform state storage
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name_value
}

resource "aws_s3_bucket_ownership_controls" "my_bucket_ownership" {
  bucket = aws_s3_bucket.my_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "my_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.my_bucket_ownership]

  bucket = aws_s3_bucket.my_bucket.id
  acl    = "private"
}