resource "spacelift_context" "infracost" {
  description = "config needed for infracost integration"
  name        = "infraost-config"
  labels      = ["autoattach:infracost"]
  space_id    = "root"
}

resource "spacelift_environment_variable" "infracost_api_key" {
  context_id = spacelift_context.infracost.id
  name       = "INFRACOST_API_KEY"
  value      = ""
  write_only = true
}
