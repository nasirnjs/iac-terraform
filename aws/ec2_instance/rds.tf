# Create an RDS instance in the private subnet
resource "aws_db_instance" "my_rds" {
  identifier          = format("%s-rds", var.environment)
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t2.micro"
  allocated_storage   = 20  
  db_subnet_group_name = aws_subnet.rds_private_subnet
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  multi_az            = false
  publicly_accessible = false  
  storage_encrypted   = true
  username            = "admin"
  password            = var.db_password
  db_name             = "mydatabase"
  skip_final_snapshot = true

  tags = {
    Name       = format("%s-my-rds", var.environment)
    Environment = var.environment
  }

  depends_on = [
    aws_vpc.ec2_vpc,
    aws_subnet.rds_private_subnet,                     
    aws_security_group.rds_sg,          
    aws_db_subnet_group.rds_subnet_group
  ]
}
resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = format("%s-rds-subnet-group", var.environment)
  subnet_ids  = [aws_subnet.rds_private_subnet.id]

  tags = {
    Name       = format("%s-rds-subnet-group", var.environment)
    Environment = var.environment
  }
}
