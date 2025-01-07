module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "5.0"

  identifier = "finops-rds-mysql"
  engine     = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"
  allocated_storage = 20

  username = "admin"
  password = "supersecretpassword"

  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_ids             = module.vpc.private_subnets

  tags = {
    Name        = "FinOps-RDS"
    Environment = "Test"
  }
}