terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.78.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}
# Define a VPC
resource "aws_vpc" "example_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "ExampleVPC"
  }
}

# Define a subnet within the VPC
resource "aws_subnet" "example_subnet" {
  vpc_id            = aws_vpc.example_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "ExampleSubnet"
  }
}

# Explicitly declare that the security group depends on the subnet
resource "aws_security_group" "example_sg" {
  name_prefix = "example-sg"

  # Explicit dependency on subnet
  depends_on = [aws_subnet.example_subnet]

  tags = {
    Name = "ExampleSecurityGroup"
  }
}

# # Output the VPC ID
# output "vpc_id" {
#   value = aws_vpc.example_vpc.id
#   description = "The ID of the created VPC"
# }

# # Output the Subnet ID
# output "subnet_id" {
#   value = aws_subnet.example_subnet.id
#   description = "The ID of the created Subnet"
# }

# # Output the Security Group ID
# output "security_group_id" {
#   value = aws_security_group.example_sg.id
#   description = "The ID of the created Security Group"
# }