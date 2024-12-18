resource "spacelift_blueprint" "s3_blueprint" {
  name        = "s3 blueprint"
  description = "creates an s3 bucket"
  space       = spacelift_space.pulumi.id
  state       = "PUBLISHED"
  template    = file("blueprints/s3.yaml")
}
