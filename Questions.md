
### 4. What is a Resource in Terraform?

A resource represents a real infrastructure object like:

* EC2 instance
* VPC
* Kubernetes cluster

### 9. What is Terraform State?

Terraform state is a file (`terraform.tfstate`) that stores:

* Resource mappings
* Metadata
* Current infrastructure state


### 10. Why is Terraform state important?

* Tracks resources
* Enables updates instead of recreation
* Prevents drift


### 11. What is Remote State?

Storing state remotely (instead of locally), e.g.:

* S3
* GCS

Benefits:

* Collaboration
* Locking
* Security

Remote backend but no real exampl
```yaml
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}
```
### 12. What is State Locking?

Prevents multiple users from modifying state simultaneously.

Example:

* DynamoDB locking (AWS)


### 19. What is Terraform Backend?

Backend defines:

* Where state is stored
* How operations are executed

Example:

* S3 backend
* Remote backend

### 20. Difference between `count` and `for_each`?

| Feature   | count               | for_each         |
| --------- | ------------------- | ---------------- |
| Type      | Index-based         | Key-based        |
| Best for  | Identical resources | Unique resources |
| Stability | Less stable         | More stable      |


### 21. What is Terraform Workspace?

Allows multiple environments:

* dev
* staging
* prod


### 22. What is Dependency in Terraform?

Terraform automatically builds dependency graph.

You can explicitly define using:

```hcl
depends_on = []
```


### 23. What is Provisioner in Terraform?

Used to execute scripts on resources.

Examples:

* remote-exec
* local-exec

⚠️ Not recommended for production (use configuration management tools instead)


### 24. What is a Data Source?

Used to fetch existing infrastructure data.

Example:

```hcl
data "aws_ami" "example" {}
```

### 26. How do you manage multiple environments in Terraform?

Options:

* Workspaces
* Separate state files
* Folder structure (best practice)

### 27. How do you handle secrets in Terraform?

* Environment variables
* Vault
* Avoid hardcoding secrets

### 28. How do you avoid state file conflicts in team environments?

* Use remote backend
* Enable state locking
* Use CI/CD pipelines

### 29. How do you manage drift in Terraform?

* Run `terraform plan`
* Use `terraform refresh`
* Monitor infrastructure

### 30. How do you integrate Terraform in CI/CD?

Tools:

* Jenkins
* GitHub Actions
* GitLab CI

Steps:

1. Validate
2. Plan
3. Manual approval
4. Apply


### 32. What are lifecycle rules?

Control resource behavior:

```hcl
lifecycle {
  create_before_destroy = true
  prevent_destroy       = true
}
```

### 33. What is `taint` and `untaint`?

* `taint` → forces resource recreation
* `untaint` → removes taint from resource

### 34. How do you import existing resources?

```bash
terraform import aws_instance.example i-123456
```

