resource "aws_s3_bucket" "pulumi_state" {
  bucket = "pulimi-state-bucket"

  tags = {
    Name        = "pulumi"
    Environment = "spacelift"
  }
}
