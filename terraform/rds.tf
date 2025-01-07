module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.0"

  identifier          = "finops-rds-mysql"
  engine              = "mysql"
  engine_version      = "8.0"
  major_engine_version = "8.0" # Add this argument
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  family              = "mysql8.0" # Add this argument

  username = "admin"
  password = "supersecretpassword"

  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_ids             = module.vpc.private_subnets

  tags = {
    Name        = "FinOps-RDS"
    Environment = "Test"
  }
}