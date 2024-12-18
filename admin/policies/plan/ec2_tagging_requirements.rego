package spacelift

import future.keywords

required_tags := {
	"Name",
    "CostCenter"
}

deny[sprintf("resource %q does not have required tags (%s)", [step.urn, concat(", ", missing_tags)])] {
	step := input.pulumi.steps[_]
    step.type == "aws:ec2/instance:Instance"
	tags := step.new.inputs.tags
	missing_tags := {tag | required_tags[tag]; not tags[tag]}
	count(missing_tags) > 0
}