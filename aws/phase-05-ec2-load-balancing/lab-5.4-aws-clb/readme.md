# Lab 5.4 — AWS Classic Load Balancer (CLB)

Provision an internet-facing Classic Load Balancer (legacy ELB) in front of EC2 instances running Nginx in private subnets.

## Architecture

- **VPC:** 3 AZs, 3 public + 3 private subnets, single NAT gateway
- **CLB:** HTTP listener on :80, instances registered directly (no target groups), health check `HTTP:80/`
- **EC2:** N instances (default 2) running Nginx, provisioned via `terraform-aws-modules/ec2-instance/aws` v6.4.0
- **SGs:** CLB open to internet on 80; EC2 only accepts 80 from CLB SG

> Note: Classic Load Balancer is a legacy AWS load balancer type. For new workloads, prefer ALB (Lab 5.2) or NLB (Lab 5.3). This lab is for educational comparison.

## File layout

| File              | Purpose                                          |
| ----------------- | ------------------------------------------------ |
| `0-provider.tf`   | AWS provider, region                             |
| `1-variables.tf`  | Input variable declarations                      |
| `terraform.tfvars`| Input values                                     |
| `2-vpc.tf`        | VPC + subnets + NAT (terraform-aws-modules/vpc)  |
| `3-sg.tf`         | CLB and web instance security groups             |
| `4-ec2.tf`        | Web EC2 instances (terraform-aws-modules/ec2-instance) |
| `5-clb.tf`        | Classic Load Balancer + listener + health check  |
| `6-outputs.tf`    | CLB DNS, app URL, instance IDs/IPs               |

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
- [terraform-aws-modules/ec2-instance/aws](https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest)
- [terraform-aws-modules/security-group/aws](https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest)
- [AWS provider — aws_elb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elb)
