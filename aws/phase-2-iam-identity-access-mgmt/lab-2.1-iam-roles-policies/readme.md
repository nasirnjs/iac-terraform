
# Lab 2.1 — IAM Role for EC2 with S3 Read-Only Access

# 👤 IAM User vs 🔐 IAM Role

## 👤 IAM User (Human Access)
* Used by **people (DevOps, developers)**
* Has **permanent credentials** (password / access key)
* Used for AWS Console / CLI login

## 🔐 IAM Role (AWS Resource Access)
* Used by **AWS services (EC2, Lambda, EKS, etc.)**
* Has **temporary credentials**
* No login, only "assumed"
* More **secure and recommended**

# 🧠 Simple Rule
* **Humans → IAM User**
* **AWS Services → IAM Role**

---

## 🎯 What this lab builds

An EC2 instance launched into the **default VPC** that can read from S3 —
without any baked-in access keys — by attaching an **IAM Role** through an
**Instance Profile**.

### Resource flow
```
EC2 instance  (t3.micro, in default VPC's first subnet)
   └── IAM Instance Profile  (ec2-s3-read-profile — the bridge)
         └── IAM Role  (ec2-s3-read-role, assumed by ec2.amazonaws.com)
               └── AmazonS3ReadOnlyAccess  (AWS-managed policy)
```

### Resources created
| Resource | Name | Purpose |
| --- | --- | --- |
| `data.aws_vpc.default` | — | Looks up the account's default VPC |
| `data.aws_subnets.default` | — | Lists subnets in the default VPC |
| `aws_iam_role` | `ec2-s3-read-role` | Trust policy lets the EC2 service assume this role |
| `aws_iam_role_policy_attachment` | — | Attaches `AmazonS3ReadOnlyAccess` managed policy |
| `aws_iam_instance_profile` | `ec2-s3-read-profile` | Wrapper that lets an EC2 instance use the role |
| `module.ec2_instance` | `single-instance` | EC2 (`t3.micro`, monitoring on) with `iam_instance_profile` set |

### EC2 module details
* **Source:** `terraform-aws-modules/ec2-instance/aws` (version `6.4.0`)
* **Instance type:** `t3.micro`
* **Subnet:** first subnet returned from the default VPC
* **Detailed monitoring:** enabled
* **Tags:** `Terraform=true`, `Environment=dev`

---

## 🚀 Usage

```bash
terraform init
terraform plan
terraform apply
```

After apply, SSH into the instance and verify the role works:

```bash
# Confirm the instance is using the role
aws sts get-caller-identity

# Read-only actions should succeed
aws s3 ls

# Write actions should fail with AccessDenied (proof of least-privilege)
aws s3 mb s3://some-new-bucket-test-123
```

## 🧹 Cleanup

```bash
terraform destroy
```
