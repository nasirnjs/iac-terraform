# Lab 6.1 — AWS RDS PostgreSQL

Provision an Amazon RDS for PostgreSQL instance inside a custom VPC, with an EC2 web instance that can reach the database over a private security group rule.

## References

- [terraform-aws-modules/rds/aws](https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/latest)
- [terraform-aws-modules/vpc/aws](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
- [terraform-aws-modules/security-group/aws](https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest)
- [terraform-aws-modules/ec2-instance/aws](https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest)

## What gets created

- VPC with public + private subnets across 3 AZs, IGW, NAT Gateway, route tables
- EC2 instance (`t3a.medium`, Ubuntu) in a public subnet with nginx user-data
- Two security groups
  - `web-service` — 22/80/443 from internet
  - `rds-postgresql-sg` — 5432 from web SG and from `db_allowed_cidr`
- RDS PostgreSQL 16
  - `db.t4g.micro`, gp3 20 GiB, encrypted at rest
  - Private subnets only, `publicly_accessible = false`
  - Custom parameter group `<identifier>-pg` with `max_connections` and `log_min_duration_statement`
  - Master password supplied via write-only attribute (`password_wo`) — not stored in state


