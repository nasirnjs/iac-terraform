# To create a Multi-AZ RDS cluster
resource "aws_rds_cluster" "example" {
  cluster_identifier        = "example"
  availability_zones        = ["us-west-2a", "us-west-2b", "us-west-2c"]
  engine                    = "mysql"
  db_cluster_instance_class = "db.t2.small"
  storage_type              = "io1"
  allocated_storage         = 10
  iops                      = 1000
  master_username           = "test"
  master_password           = "mustbeeightcharaters"
}
