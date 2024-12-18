resource "spacelift_space" "opentofu" {
  name             = "opentofu"
  inherit_entities = true
  parent_space_id  = "root"
}

resource "spacelift_space" "pulumi" {
  name             = "pulumi"
  inherit_entities = true
  parent_space_id  = "root"
}
