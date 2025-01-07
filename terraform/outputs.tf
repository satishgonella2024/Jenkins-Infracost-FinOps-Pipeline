output "vpc_id" {
  value = module.vpc.vpc_id
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "db_instance_identifier" {
  value = module.rds.db_instance_identifier
}

output "rds_endpoint" {
  value = module.rds.db_instance_endpoint
}