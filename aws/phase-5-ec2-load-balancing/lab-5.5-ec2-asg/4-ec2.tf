# ----------------------------------------------------------------------------
# EC2 instances — static targets behind the ALB
# ----------------------------------------------------------------------------
resource "aws_instance" "web" {
  count = var.instance_count

  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = element(module.vpc.private_subnets, count.index)
  vpc_security_group_ids = [module.web_service_sg.security_group_id]

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_disk_size
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
    echo "<h1>Hello from $INSTANCE_ID</h1>" > /var/www/html/index.html
  EOF

  tags = {
    Name        = "${var.environment}-web-${count.index + 1}"
    Terraform   = "true"
    Environment = var.environment
  }
}

resource "aws_lb_target_group_attachment" "web" {
  count = var.instance_count

  target_group_arn = module.alb.target_groups["web-tg"].arn
  target_id        = aws_instance.web[count.index].id
  port             = 80
}
