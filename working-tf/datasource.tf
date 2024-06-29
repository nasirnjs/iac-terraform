

provider "aws" {
  region     = "us-east-2"
}

# main.tf

data "aws_ami" "latest_ubuntu" {
  most_recent = true

  owners = ["amazon"]  # Canonical account ID for Ubuntu AMIs

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*22.04-*"]  # Example pattern for Ubuntu 18.04 LTS AMIs
  }
}

output "ubuntu_ami_id" {
  value = data.aws_ami.latest_ubuntu.id
}
