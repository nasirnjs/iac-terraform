Update a kubeconfig file for your cluster Replace region-code with the AWS Region that your cluster Name

`aws eks --region us-east-1 update-kubeconfig --name buddy-cluster`




## Create json Policy
[cluster-auto-scaler-json Policy](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md)




## Create custom trusted role and attach policy
EKS cluster manifest file from [Here](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml)

Note:
    - during create cluster role select your actual cluster oidc
    - registry.k8s.io/autoscaling/cluster-autoscaler:**v1.31** #change your k8s version
    - annotations:
        eks.amazonaws.com/role-arn: arn:aws:iam::xxxxx:role/Amazon_CA_role   # Add the IAM role created in  section. [Ref](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/CA_with_AWS_IAM_OIDC.md)

## Eid role trusted relationship

```sh
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Principal": {
				"Federated": "arn:aws:iam::699475925713:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/49E579257FC65BDE57875249964EBDCB"
			},
			"Action": "sts:AssumeRoleWithWebIdentity",
			"Condition": {
				"StringEquals": {
					"oidc.eks.us-east-1.amazonaws.com/id/49E579257FC65BDE57875249964EBDCB:aud": "sts.amazonaws.com",
					"oidc.eks.us-east-1.amazonaws.com/id/49E579257FC65BDE57875249964EBDCBD:sub": "system:serviceaccount:kube-system:cluster-autoscaler"
				}
			}
		}
	]
}

```