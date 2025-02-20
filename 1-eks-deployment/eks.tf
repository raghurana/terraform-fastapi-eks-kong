module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.32.0"

  cluster_name                   = var.name
  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["t3.small"]

    attach_cluster_primary_security_group = true
  }

  eks_managed_node_groups = {
    
    ss-cluster-wg = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.small"]
      capacity_type  = "SPOT"

      tags = {
        name = "MyNodeGroup"
      }
    }
  }

  # 🚀 New Fargate Profile
  fargate_profiles = {
    default = {
      cluster_name           = module.eks.cluster_name
      fargate_profile_name = "default"
      namespace            = "fargate-apps"
      subnet_ids           = module.vpc.private_subnets

      selectors = [
        {
          namespace = "fargate-apps"
        }
      ]
    }
  }


  tags = {
    Example = var.name
  }
}