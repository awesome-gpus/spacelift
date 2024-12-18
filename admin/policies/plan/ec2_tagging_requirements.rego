package spacelift

sample := true

deny {
  input.pulumi.steps[_].type == "aws:ec2/instance:Instance"
  input.pulumi.steps[_].new.inputs.instanceType == "t2.microasdf"
}