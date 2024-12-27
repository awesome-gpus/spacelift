resource "spacelift_policy" "cost_estimation" {
  name        = "cost estimate with infracost"
  body        = file("./policies/plan/cost_estimation.rego")
  type        = "PLAN"
  description = "This policy utilizes Infracost data to enforce cost controls on infrastructure deployments"
  space_id    = "root"
  labels      = ["autoattach:infracost"]
}

resource "spacelift_policy" "ec2_tagging_requirements" {
  name        = "ec2 tagging requirements"
  body        = file("./policies/plan/ec2_tagging_requirements.rego")
  type        = "PLAN"
  description = "This policy enforces EC2 tagging requirements"
  space_id    = "root"
  labels      = ["autoattach:*"]
}

resource "spacelift_policy" "tfsec_evaluation" {
  name        = "tfsec evaluation"
  body        = file("./policies/plan/tfsec_evaluation.rego")
  type        = "PLAN"
  description = "This policy evalutates tfsec output for high severity."
  space_id    = "root"
  labels      = ["autoattach:security"]
}

resource "spacelift_policy" "tag_driven_module_version_release" {
  name        = "tag-driven module version release workflow"
  body        = file("./policies/push/tag_driven_module_version_release.rego")
  type        = "GIT_PUSH"
  description = "This module will automatically release a new module version based on git tags"
  space_id    = "root"
  labels      = ["autoattach:module"]
}

resource "spacelift_policy" "slack_notification" {
  name        = "slack notification"
  body        = file("./policies/notification/slack_notification.rego")
  type        = "NOTIFICATION"
  description = "This policy is used send a notification to Slack when a run succeeds."
  space_id    = "root"
  labels      = ["autoattach:*"]
}

resource "spacelift_policy" "pr_notification" {
  name        = "pull request notification"
  body        = file("./policies/notification/pr_comment.rego")
  type        = "NOTIFICATION"
  description = "This policy will add a comment to a pull request where it will list all the resources that were added, changed, deleted, moved, imported or forgotten."
  space_id    = "root"
  labels      = ["autoattach:*"]
}
