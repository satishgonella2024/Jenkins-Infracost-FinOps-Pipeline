module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "19.0"

  cluster_name    = "finops-eks-cluster"
  cluster_version = "1.25"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets

  # Define managed node groups
  eks_managed_node_groups = {
    default = {
      name             = "default-node-group"
      desired_capacity = 2
      max_size         = 3
      min_size         = 1
      instance_types   = ["t3.medium"]
    }
  }

  tags = {
    Name        = "FinOps-EKS-Cluster"
    Environment = "Test"
  }
}