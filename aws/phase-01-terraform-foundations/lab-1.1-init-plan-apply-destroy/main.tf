# Get Default VPC
data "aws_vpc" "default" {
  default = true
}

# Get a subnet from Default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.4.0"

  name          = "single-instance"
  instance_type = "t3.micro"

  # Automatically use first default subnet
  subnet_id = data.aws_subnets.default.ids[0]

  key_name = "user1"

  monitoring = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}