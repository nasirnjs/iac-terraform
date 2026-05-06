# ----------------------------------------------------------------------------
# EC2 instances — static targets behind the CLB
# ----------------------------------------------------------------------------
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.4.0"

  count = var.instance_count

  name = "${var.environment}-web-${count.index + 1}"

  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = element(module.vpc.private_subnets, count.index)
  vpc_security_group_ids = [module.web_service_sg.security_group_id]

  disable_api_termination = false

  root_block_device = {
    type                  = "gp3"
    size                  = var.root_disk_size
    encrypted             = true
    delete_on_termination = true
  }

  user_data = <<-EOF
    #!/bin/bash
    set -euxo pipefail
    apt-get update -y
    apt-get install -y nginx
    systemctl enable nginx
    systemctl start nginx
    TOKEN=$(curl -sS -X PUT "http://169.254.169.254/latest/api/token" \
      -H "X-aws-ec2-metadata-token-ttl-seconds: 60")
    INSTANCE_ID=$(curl -sS -H "X-aws-ec2-metadata-token: $TOKEN" \
      http://169.254.169.254/latest/meta-data/instance-id)
    echo "<h1>Hello from $INSTANCE_ID</h1>" > /var/www/html/index.html
  EOF

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}
