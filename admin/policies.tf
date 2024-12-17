resource "spacelift_policy" "cost_estimation" {
  name        = "cost estimate with infracost"
  body        = file("./policies/plan/cost_estimate.rego")
  type        = "PLAN"
  description = "This policy utilizes Infracost data to enforce cost controls on infrastructure deployments"
  space_id    = "root"
  labels      = ["autoattach:infracost"]
}

resource "spacelift_policy" "tag_driven_module_version_release" {
  name        = "tag-driven module version release workflow"
  body        = file("./policies/push/tag_driven_module_version_release.rego")
  type        = "GIT_PUSH"
  description = "This module will automatically release a new module version based on git tags"
  space_id    = "root"
  labels      = ["autoattach:module"]
}