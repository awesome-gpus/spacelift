package spacelift

deny [sprintf(message, [p])] {
	message := "You have a couple of high serverity issues: %d"
	results := input.third_party_metadata.custom.tfsec.results
    p := count({result | result := results[_]; result.severity == "HIGH"})
    p >= 5
}
sample = true