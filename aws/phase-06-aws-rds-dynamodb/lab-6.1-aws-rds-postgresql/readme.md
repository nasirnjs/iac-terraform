# Lab 6.1 — AWS RDS PostgreSQL

Provision an Amazon RDS for PostgreSQL instance inside a custom VPC, with an EC2 web instance that can reach the database over a private security group rule.

## References

- [terraform-aws-modules/rds/aws](https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/latest)
- [terraform-aws-modules/vpc/aws](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
- [terraform-aws-modules/security-group/aws](https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest)
- [terraform-aws-modules/ec2-instance/aws](https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest)


## Connect Securely to Amazon RDS PostgreSQL Using SSL from Ubuntu
```
# Download AWS RDS SSL Certificate Bundle
curl -o global-bundle.pem https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem

# Set RDS Endpoint
export RDSHOST="prod-postgresql.cdmqiqkkubo9.us-east-2.rds.amazonaws.com"

# Connect Securely to PostgreSQL RDS
psql "host=$RDSHOST port=5432 dbname=appdb user=postgres sslmode=verify-full sslrootcert=./global-bundle.pem"
```