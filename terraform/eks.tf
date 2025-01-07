module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "19.0"

  cluster_name    = "finops-eks-cluster"
  cluster_version = "1.25"
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.private_subnets

  node_groups = {
    default = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_type    = "t3.medium"
    }
  }

  tags = {
    Name        = "FinOps-EKS-Cluster"
    Environment = "Test"
  }
}