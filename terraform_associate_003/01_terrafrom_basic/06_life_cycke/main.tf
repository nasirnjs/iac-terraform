provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-005fc0f236362e99f"    # Initial AMI
  instance_type = "t2.small"

  tags = {
    Name = "example-instance"
  }

  lifecycle {
    # Ensure the new instance is created before the old one is destroyed
    #prevent_destroy = true
    create_before_destroy = true
  }
}
