
# Terraform S3 Bucket Configuration Summary

This Terraform configuration sets up an AWS S3 storage solution with the following key features:

## 1. S3 Bucket Creation
- Creates a main S3 bucket with a dynamic name and tags.

## 2. File Upload
- Uploads files from a local directory to the S3 bucket with AES256 encryption.

## 3. Ownership Controls
- Configures ownership control to ensure the bucket owner retains full control over all objects.

## 4. Public Access Block
- Modifies public access settings to allow certain public access configurations.

## 5. Bucket Policies
- Grants **public read access** to objects.
- Grants **write permissions** to a specific IAM user (`kader`).

## 6. Encryption
- Configures **server-side encryption** using a custom KMS key.

## 7. Versioning
- Enables **versioning** on the S3 bucket to retain multiple object versions.

## 8. Lifecycle Rules
- Defines **lifecycle rules** for object transitions and expiration based on object age:
  - Transitions objects to **STANDARD_IA** after 30 days.
  - Transitions objects to **GLACIER** after 60 days.
  - Expires noncurrent versions after 90 days.

## 9. Logging
- Configures **logging** to a separate log bucket for tracking access to the main bucket.

## 10. Object Locking
- Applies **object locking** for compliance with a retention period of 1 day.

## 11. Outputs
- Outputs the names of the **main S3 bucket** and the **log bucket**.


*Attach this Permission of current user*

```bash
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": "s3:*",
			"Resource": [
				"arn:aws:s3:::*",
				"arn:aws:s3:::*/*"
			]
		}
	]
}
```



`aws s3 cp test-file.txt s3://yourmentors-devops-bucket --acl public-read`


`https://yourmentors-devops-bucket.s3.us-east-1.amazonaws.com/test-file.txt`