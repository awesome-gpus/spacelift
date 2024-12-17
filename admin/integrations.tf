resource "spacelift_aws_integration" "demo_aws_integration" {
  name     = "demo"
  role_arn = var.role_arn
  space_id = spacelift_space.aws.id
}

locals {
  spacelift_hostname = "awesome-gpus"
}
