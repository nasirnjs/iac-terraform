
[References](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)


[References 2](https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest#input_root_block_device)


VPC Module will automatically create:

- 1 VPC
- 1 Internet Gateway
- 1 NAT Gateway
- 1 Elastic IP for the NAT Gateway
- Public route table(s)
- Private route table(s)
- Public subnets
- Private subnets
- Route table associations for all subnets

Your tag blocks only customize names

```
igw_tags = {
  Name = "${var.environment}-internet-gateway"
}
```

