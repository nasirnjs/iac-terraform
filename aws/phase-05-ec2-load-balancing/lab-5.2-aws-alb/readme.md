# Lab 5.2 — AWS Application Load Balancer (ALB)

Provision an internet-facing ALB in front of EC2 instances running Nginx in private subnets.

## Architecture

- **VPC:** 3 AZs, 3 public + 3 private subnets, single NAT gateway
- **ALB:** HTTP listener on :80, forwards to `web` target group, health check `GET /`
- **EC2:** N instances (default 2) running Nginx, registered as ALB targets
- **SGs:** ALB open to internet on 80; EC2 only accepts 80 from ALB SG

## File layout

| File             | Purpose                                          |
| ---------------- | ------------------------------------------------ |
| `provider.tf`    | AWS provider, region                             |
| `variables.tf`   | Input variable declarations                      |
| `terraform.tfvars` | Input values                                   |
| `vpc.tf`         | VPC + subnets + NAT (terraform-aws-modules/vpc)  |
| `sg.tf`          | ALB and web instance security groups             |
| `alb.tf`         | Application Load Balancer + listener + TG        |
| `ec2.tf`         | Web EC2 instances + target group attachments     |
| `outputs.tf`     | ALB DNS, app URL, instance IDs/IPs               |

## Prerequisites

- Terraform `>= 1.5`
- AWS credentials (`aws configure` or env vars) with EC2/VPC/ELB permissions
- An existing EC2 key pair in the target region — set via `key_name`

## Usage

```bash
terraform init
terraform plan
terraform apply
```

Targets typically pass health checks within 30–60s of instance creation.

## Inputs

| Name                 | Type           | Default | Description                              |
| -------------------- | -------------- | ------- | ---------------------------------------- |
| `vpc_name`           | string         | —       | Name of the VPC                          |
| `vpc_cidr_block`     | string         | —       | VPC CIDR (e.g., `10.0.0.0/16`)           |
| `environment`        | string         | —       | Environment tag (`dev`, `prod`, ...)     |
| `availability_zones` | list(string)   | —       | AZ list                                  |
| `public_subnets`     | list(string)   | —       | Public subnet CIDRs                      |
| `private_subnets`    | list(string)   | —       | Private subnet CIDRs                     |
| `ami`                | string         | —       | EC2 AMI ID (Ubuntu recommended)          |
| `instance_type`      | string         | —       | EC2 instance type                        |
| `key_name`           | string         | —       | Existing EC2 key pair name               |
| `root_disk_size`     | number         | —       | Root EBS volume size (GiB)               |
| `instance_count`     | number         | `2`     | Number of EC2 web instances              |



## References

- [terraform-aws-modules/vpc/aws](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
- [terraform-aws-modules/alb/aws](https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/latest)
- [terraform-aws-modules/security-group/aws](https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest)
