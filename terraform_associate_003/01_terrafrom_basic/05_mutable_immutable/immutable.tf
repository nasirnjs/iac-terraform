resource "aws_instance" "example_instance" {
  ami           = "ami-12345678"       # Initial AMI
  instance_type = "t2.micro"           # Initial instance type
  tags = {
    Name = "ExampleInstance"
  }
}

# In immutable infrastructure, when we want to update the instance, we create a new resource with different configurations:
resource "aws_instance" "example_instance_v2" {
  ami           = "ami-87654321"       # New AMI (updated version)
  instance_type = "t2.medium"          # Changed instance type (immutable change)
  tags = {
    Name = "ExampleInstance_v2"
  }
}