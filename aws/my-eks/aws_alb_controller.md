
# AWS Load Balancer Controller


## Steps 1: Create IAM policy for Load Balancer Controller.\
IAM policy for the AWS Load Balancer Controller from [Here](curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json)


## Steps 2: Create Role for Load Balancer Controller
Create IAM role for Load Balancer Controller and attached IAM policy, that you have created on *Steps 1*

**Note:** role should be *Web identity* and select your cluster oidc and Identity provider should be *sts.amazonaws.com*



## Steps 3: Update Role Trust relationships
```bash
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Principal": {
				"Federated": "arn:aws:iam::699475925713:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/01F880F8A713E378F9D2F532956D591D"
			},
			"Action": "sts:AssumeRoleWithWebIdentity",
			"Condition": {
				"StringEquals": {
					"oidc.eks.us-east-1.amazonaws.com/id/01F880F8A713E378F9D2F532956D591D:sub": "system:serviceaccount:kube-system:alb-ingress-controller",
					"oidc.eks.us-east-1.amazonaws.com/id/01F880F8A713E378F9D2F532956D591D:aud": "sts.amazonaws.com"
				}
			}
		}
	]
}
```

## Steps 4: Install AWS ALB ingress controller via Helm


`helm repo add eks https://aws.github.io/eks-charts`

```bash
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
--set clusterName=buddy-cluster \
--set vpcId=vpc-0ee136d6d4a5a290c \
--set serviceAccount.create=true \
--set serviceAccount.name=alb-ingress-controller \
--set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"="arn:aws:iam::699475925713:role/aws_load_balancer_controller_role" \
--namespace kube-system
```

## Steps 5: Deploy Ingree and Application.\
[Example](https://github.com/kubernetes-sigs/aws-load-balancer-controller/blob/main/docs/examples/2048/2048_full.yaml)



[Refereces1](https://docs.aws.amazon.com/eks/latest/userguide/lbc-helm.html)
[Refereces2](https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html)
[Refereces3](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/guide/ingress/annotations/)
[Refereces4](https://github.com/kubernetes-sigs/aws-load-balancer-controller/tree/main)
[Refereces5](https://harsh05.medium.com/path-based-routing-with-aws-load-balancer-controller-an-ingress-journey-on-amazon-eks-733d3c6c5adf)

