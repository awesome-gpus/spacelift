variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket to create."
}

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
}

output "bucket" {
  value = aws_s3_bucket.this
}