vpc_name       = "prod-vpc"
vpc_cidr_block = "10.0.0.0/16"
environment    = "prod"

availability_zones = [
  "us-east-2a",
  "us-east-2b",
  "us-east-2c"
]

public_subnets = [
  "10.0.101.0/24",
  "10.0.102.0/24",
  "10.0.103.0/24"
]

private_subnets = [
  "10.0.1.0/24",
  "10.0.2.0/24",
  "10.0.3.0/24"
]

instance_type  = "t3a.medium"
key_name       = "nasir-us-east-2-key"
ami            = "ami-05ee577e8ba991681"
root_disk_size = 20

# Auto Scaling Group
asg_min_size         = 2
asg_max_size         = 4
asg_desired_capacity = 2
asg_cpu_target       = 60

# DNS / TLS
domain_name               = "nasirtechtalks.com"
route53_zone_name         = "nasirtechtalks.com"
subject_alternative_names = ["www.nasirtechtalks.com"]
create_acm_certificate    = true
#acm_certificate_arn = "arn:aws:acm:ap-southeast-1:123456789012:certificate/xxxxxx"
