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
  project_root      = "opentofu/vpc"
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
  manage_state    = false

  # Optional inputs 
  aws_integration = {
    enabled = true
    id      = spacelift_aws_integration.demo_aws_integration.id
  }
  labels            = ["aws", "ec2", "infracost"]
  project_root      = "opentofu/ec2"
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

module "stack_aws_vpc_kubernetes_example" {
  source = "spacelift.io/spacelift-solutions/stacks-module/spacelift"

  description     = "stack that creates a VPC for the Kubernetes Example"
  name            = "kubernetes-vpc"
  repository_name = "spacelift"
  space_id        = spacelift_space.opentofu.id

  aws_integration = {
    enabled = true
    id      = spacelift_aws_integration.demo_aws_integration.id
  }
  labels            = ["aws", "vpc"]
  project_root      = "vpc"
  repository_branch = "main"
  tf_version        = "1.8.4"

  dependencies = {
    EKS = {
      child_stack_id = module.stack_aws_eks_kubernetes_example.id

      references = {
        VPC_ID = {
          output_name    = "vpc_id"
          input_name     = "TF_VAR_vpc_id"
          trigger_always = true
        }
        SUBNET_IDS = {
          output_name    = "private_subnets"
          input_name     = "TF_VAR_subnet_ids"
          trigger_always = true
        }
      }
    }
  }
}

module "stack_aws_eks_kubernetes_example" {
  source = "spacelift.io/spacelift-solutions/stacks-module/spacelift"

  description     = "stack that creates an EKS Cluster for the Kubernetes Example"
  name            = "eks-cluster"
  repository_name = "spacelift"
  space_id        = spacelift_space.opentofu.id

  aws_integration = {
    enabled = true
    id      = spacelift_aws_integration.demo_aws_integration.id
  }

  labels            = ["aws", "kubernetes"]
  project_root      = "eks"
  repository_branch = "main"
  tf_version        = "1.8.4"
}

module "stack_aws_eks_worker_pool" {
  source          = "spacelift.io/spacelift-solutions/stacks-module/spacelift"
  description     = "stack to deploy private workers on AWS EKS"
  name            = "worker pool on EKS"
  repository_name = "spacelift"
  space_id        = spacelift_space.opentofu.id

  aws_integration = {
    enabled = true
    id      = spacelift_aws_integration.demo_aws_integration.id
  }

  labels            = ["aws", "eks"]
  project_root      = "worker-pool"
  repository_branch = "main"
  tf_version        = "1.8.4"
  dependencies = {
    ADMIN = {
      parent_stack_id = data.spacelift_current_stack.admin.id
      references = {
        WORKER_POOL_ID = {
          output_name = "eks_worker_pool_id"
          input_name  = "TF_VAR_worker_pool_id"
        }
        WORKER_POOL_CONFIG = {
          output_name = "eks_worker_pool_config"
          input_name  = "TF_VAR_worker_pool_config"
        }
        WORKER_POOL_PRIVATE_KEY = {
          output_name = "eks_worker_pool_private_key"
          input_name  = "TF_VAR_worker_pool_private_key"
        }
      }
    }
    EKS = {
      parent_stack_id = module.stack_aws_eks_kubernetes_example.id
      references = {
        CLUSTER_NAME = {
          output_name = "cluster_name"
          input_name  = "TF_VAR_cluster_name"
        }
        CLUSTER_ENDPOINT = {
          output_name = "cluster_endpoint"
          input_name  = "TF_VAR_cluster_endpoint"
        }
        CLUSTER_CA_DATA = {
          output_name = "cluster_certificate_authority_data"
          input_name  = "TF_VAR_cluster_certificate_authority_data"
        }
      }
    }
  }
}
