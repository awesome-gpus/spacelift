module "stack_aws_vpc" {
  source = "spacelift.io/spacelift-solutions/stacks-module/spacelift"

  # Required inputs 
  description     = "stack that creates a VPC and handles networking"
  name            = "networking"
  repository_name = "spacelift"
  space_id        = spacelift_space.opentofu.id

  # Optional inputs 
  aws_integration = {
    enabled = true
    id      = spacelift_aws_integration.demo_aws_integration.id
  }
  labels            = ["aws", "networking", "infracost", "security"]
  project_root      = "opentofu/aws/vpc"
  repository_branch = "main"
  tf_version        = "1.8.4"
  # worker_pool_id            = string
  dependencies = {
    EC2 = {
      child_stack_id = module.stack_aws_ec2.id

      references = {
        SUBNET = {
          output_name    = "subnetId"
          input_name     = "TF_VAR_subnetId"
          trigger_always = true
        }
        SECURITY_GROUP = {
          output_name    = "spacelift_sg"
          input_name     = "TF_VAR_aws_security_group_id"
          trigger_always = true
        }
      }
    }
  }
}

module "stack_aws_ec2" {
  source = "spacelift.io/spacelift-solutions/stacks-module/spacelift"

  # Required inputs 
  description     = "creates a simple EC2 instance"
  name            = "ec2"
  repository_name = "spacelift"
  space_id        = spacelift_space.opentofu.id

  # Optional inputs 
  aws_integration = {
    enabled = true
    id      = spacelift_aws_integration.demo_aws_integration.id
  }
  labels            = ["aws", "ec2", "infracost"]
  project_root      = "opentofu/aws/ec2"
  repository_branch = "main"
  tf_version        = "1.8.4"
  # worker_pool_id            = string
}

module "pulumi_stack_aws_ec2" {
  source = "spacelift.io/spacelift-solutions/stacks-module/spacelift"

  # Required inputs
  description     = "creates a simple EC2 instanc using pulumi"
  name            = "pulumi ec2"
  repository_name = "spacelift"
  space_id        = spacelift_space.pulumi.id

  # Optional inputs
  aws_integration = {
    enabled = true
    id      = spacelift_aws_integration.demo_aws_integration.id
  }
  labels            = ["aws", "ec2", "pulumi", "infracost"]
  project_root      = "pulumi"
  repository_branch = "main"

  runner_image = "public.ecr.aws/spacelift/runner-pulumi-python:latest"

  workflow_tool = "PULUMI"
  pulumi = {
    login_url  = "s3://spacelift-pulumi-s3-backend"
    stack_name = "pulumi-ec2"
  }

  environment_variables = {
    AWS_REGION = {
      value = "us-east-1"
    }
  }

  hooks = {
    before_init = [
      "pip install -r requirements.txt"
    ]
    before_apply = [
      "pip install -r requirements.txt"
    ]
  }

}

