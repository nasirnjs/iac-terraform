
# AWS Load Balancer Controller


## Steps 1: Create IAM policy for Load Balancer Controller.

IAM policy for the AWS Load Balancer Controller from [Here](https://docs.aws.amazon.com/eks/latest/userguide/lbc-manifest.html).\
**Steps 1.1** Download an IAM policy for the AWS Load Balancer Controller that allows it to make calls to AWS APIs on your behal.

`curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.11.0/docs/install/iam_policy.json`

**Steps 1.2** Create an IAM policy using the policy downloaded in the previous step.\
`aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://iam_policy.json`


## Steps 2: Create Role for Load Balancer Controller
Create IAM role for Load Balancer Controller and attached IAM policy, that you have created on **Steps 1**

**Note:** role should be **Web identity** and select your cluster oidc and Identity provider should be **sts.amazonaws.com**

**Steps 2.1 Get the OIDC provider**.

`aws eks describe-cluster --name buddy-cluster  --query "cluster.identity.oidc.issuer --output text`

**Steps 2.2 Create a trusted-policy via oidc provider. Example, trus-policy.json**

```bash
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::<ACCOUNT_ID>:oidc-provider/<OIDC_PROVIDER>"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
		  "<OIDC_PROVIDER>:aud": "sts.amazonaws.com",
          "<OIDC_PROVIDER>:sub": "ystem:serviceaccount:kube-system:alb-ingress-controller"
        }
      }
    }
  ]
}

```

Example

```bash
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Principal": {
				"Federated": "arn:aws:iam::605134426044:oidc-provider/oidc.eks.us-east-2.amazonaws.com/id/01F880F8A713E378F9D2F532956D591D"
			},
			"Action": "sts:AssumeRoleWithWebIdentity",
			"Condition": {
				"StringEquals": {
					"oidc.eks.us-east-2.amazonaws.com/id/01F880F8A713E378F9D2F532956D591D:sub": "system:serviceaccount:kube-system:alb-ingress-controller",
					"oidc.eks.us-east-2.amazonaws.com/id/01F880F8A713E378F9D2F532956D591D:aud": "sts.amazonaws.com"
				}
			}
		}
	]
}
```

Create the Cluster Auto Scaler IAM Role 

`aws iam create-role --role-name AmazonEKSLoadBalancerControllerRole --assume-role-policy-document file://trust-policy.json`

Retrieve the Policy ARN with AWS CLI for attach this policy with ClusterAutoscalerRole.

`aws iam list-policies --scope Local --query "Policies[?PolicyName=='AWSLoadBalancerControllerIAMPolicy'].Arn" --output text`

Attach Policy with Cluster Auto Scaler Role Using ARN.

`aws iam attach-role-policy --role-name AmazonEKSLoadBalancerControllerRole --policy-arn arn:aws:iam::605134426044:policy/AWSLoadBalancerControllerIAMPolicy`

## Steps 3: Install AWS ALB ingress controller via Helm

`helm repo add eks https://aws.github.io/eks-charts`

```bash
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
--set clusterName=buddy-cluster \
--set vpcId=vpc-0ee136d6d4a5a290c \
--set serviceAccount.create=true \
--set serviceAccount.name=alb-ingress-controller \
--set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"="arn:aws:iam::605134426044:role/AmazonEKSLoadBalancerControllerRole" \
--namespace kube-system
```

## Steps 4: Deploy Ingree and Application.\
[Example](https://github.com/kubernetes-sigs/aws-load-balancer-controller/blob/main/docs/examples/2048/2048_full.yaml)


[Refereces1](https://docs.aws.amazon.com/eks/latest/userguide/lbc-helm.html)
[Refereces2](https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html)
[Refereces3](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/guide/ingress/annotations/)
[Refereces4](https://github.com/kubernetes-sigs/aws-load-balancer-controller/tree/main)
[Refereces5](https://harsh05.medium.com/path-based-routing-with-aws-load-balancer-controller-an-ingress-journey-on-amazon-eks-733d3c6c5adf)
[Refereces6](https://www.youtube.com/watch?v=MFCtj8uz0CM)



