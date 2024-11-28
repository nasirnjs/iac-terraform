# resource "aws_instance" "example_instance" {
#   ami           = "ami-12345678"       # Initial AMI
#   instance_type = "t2.micro"           # Initial instance type
#   tags = {
#     Name = "ExampleInstance"
#   }
# }

# # Later in the same configuration, we change the instance type:
# resource "aws_instance" "example_instance" {
#   ami           = "ami-12345678"       # Same AMI (no change)
#   instance_type = "t2.medium"          # Changed instance type (mutable change)
#   tags = {
#     Name = "ExampleInstance"
#   }
# }