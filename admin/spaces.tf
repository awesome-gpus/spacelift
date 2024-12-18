resource "spacelift_space" "opentofu" {
  name             = "aws"
  inherit_entities = true
  parent_space_id  = "root"
}

resource "spacelift_space" "pulumi" {
  name             = "aws"
  inherit_entities = true
  parent_space_id  = "root"
}
