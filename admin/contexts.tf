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

resource "spacelift_context" "tfsec" {
  description = "config to install and run TFSEC"
  name        = "tfsec-config"
  labels      = ["autoattach:security"]
  before_init = ["wget -O tfsec https://github.com/aquasecurity/tfsec/releases/download/v1.28.1/tfsec-linux-amd64", "chmod +x tfsec", "./tfsec -s --format=json . > tfsec.custom.spacelift.json"]
  space_id    = "root"
}

