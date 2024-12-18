resource "spacelift_blueprint" "pulumi_s3" {
  name        = "pulumi s3 for backend"
  description = "creates an s3 bucket for pulumi backend"
  space       = spacelift_space.pulumi.id
  state       = "DRAFT"
  template    = file("blueprints/pulumi-s3.yaml")
}
