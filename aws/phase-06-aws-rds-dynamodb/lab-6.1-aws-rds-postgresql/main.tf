module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"
  version = "6.4.0"
  
  name                        = var.ec2_name
  ami                         = var.ami
  create_security_group       = false
  vpc_security_group_ids      = [module.web_service_sg.security_group_id]
  instance_type               = var.instance_type
  key_name                    = var.key_name
  monitoring                  = true
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  # Root Disk
  root_block_device = {
    type                  = "gp3"
    size                  = var.root_disk_size
    delete_on_termination = true
  }
  # User Data Sections
  user_data = <<-EOF
  #!/bin/bash
  set -euxo pipefail

  echo "Starting user data..." > /var/log/userdata.log

  apt-get update -y
  apt-get install -y nginx

  systemctl enable nginx
  systemctl start nginx

  echo "<h1>Hello from Terraform EC2</h1>" > /var/www/html/index.html

  echo "Completed successfully" >> /var/log/userdata.log
  EOF

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}