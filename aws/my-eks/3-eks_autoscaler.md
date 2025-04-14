Update a kubeconfig file for your cluster Replace region-code with the AWS Region that your cluster Name

`aws eks --region us-east-1 update-kubeconfig --name buddy-cluster`



## Steps 1:  Create Autoscaler Features Policy copy from [here](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md) make a  json file


`aws iam create-policy --policy-name AmazonEKSClusterAutoscalerPolicy --policy-document file://cluster-autoscaler-policy.json`

## Steps 2: Create custom trusted role and attach cluster-autoscaler-policy policy

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
          "<OIDC_PROVIDER>:sub": "system:serviceaccount:kube-system:cluster-autoscaler"
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
				"Federated": "arn:aws:iam::605134426044:oidc-provider/oidc.eks.us-east-2.amazonaws.com/id/153E99D5D6B6AD576A0914B87CB50E84"
			},
			"Action": "sts:AssumeRoleWithWebIdentity",
			"Condition": {
				"StringEquals": {
					"oidc.eks.us-east-2.amazonaws.com/id/153E99D5D6B6AD576A0914B87CB50E84:aud": "sts.amazonaws.com",
					"oidc.eks.us-east-2.amazonaws.com/id/153E99D5D6B6AD576A0914B87CB50E84:sub": "system:serviceaccount:kube-system:cluster-autoscaler"
				}
			}
		}
	]
}
```

Create the Cluster Auto Scaler IAM Role 

`aws iam create-role --role-name AmazonEKSClusterAutoscalerRole --assume-role-policy-document file://trust-policy.json`

Retrieve the Policy ARN with AWS CLI for attach this policy with ClusterAutoscalerRole.

`aws iam list-policies --scope Local --query "Policies[?PolicyName=='AmazonEKSClusterAutoscalerPolicy'].Arn" --output text`

Attach Policy with Cluster Auto Scaler Role Using ARN.

`aws iam attach-role-policy --role-name AmazonEKSClusterAutoscalerRole --policy-arn arn:aws:iam::605134426044:policy/AmazonEKSClusterAutoscalerPolicy`


**Steps 2.3 Apply EKSClusterAutoscal manifest, download from [Here](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml)**

**Note: Before apply update following**

1. Update annotation with cluster auto scaler role arn in ServiceAccount section.

```bash
annotations:
   eks.amazonaws.com/role-arn: arn:aws:iam::605134426044:role/AmazonEKSClusterAutoscalerRole
```
You can retrieve the mazonEKSClusterAutoscalerRole ARN using the following command.

`aws iam get-role --role-name AmazonEKSClusterAutoscalerRole --query "Role.Arn" --output text`

2. Update Deployment Cluster autoscaler pod version as exect cluster version
 
```bash
containers:
   - image: registry.k8s.io/autoscaling/cluster-autoscaler:v1.32.1
```

3. Update Deployment node-group-auto-discovery Cluster Name.
   
`- --node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/buddy-cluster`
   
1. Apply EKS cluster autoscaler-autodiscover manifest file 

`kubectl apply -f eks_cluster_autoscaler.yam`





[References](https://www.youtube.com/watch?v=__3O1Tk-26s)



# Horizontal Pod Autoscaler (HPA)

## Install Metrics Server
Amazon Elastic Kubernetes Service (EKS) automatically scales the number of pods in a deployment or replica set based on observed CPU/memory utilization or custom metrics. Here’s a step-by-step guide to configure HPA in an EKS cluster

Steps 1: Install Metrics Server: HPA relies on metrics like CPU and memory, which the Kubernetes Metrics Server provides. If it’s not already installed, deploy it.\
`kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml`


Steps 2: To confirm that Metrics Server is running, run the following command.\
`kubectl get pods -n kube-system -l k8s-app=metrics-server`

## Test HPA (Horizontal Pod Autoscaler)
To test the Horizontal Pod Autoscaler (HPA), you can generate load on the php-apache service by simulating traffic. Here’s a method to do this from within the cluster using a busy loop and also using an external load-testing tool if you’re working from outside the cluster.

Run a Load Generator Pod: Use a BusyBox pod that repeatedly makes requests to the php-apache service.\
`kubectl run -i --tty load-generator --rm --image=busybox -- /bin/sh`

Run a Loop to Generate Requests: Once inside the BusyBox shell, use wget in a loop to hit the service and create CPU load.\
`while true; do wget -q -O- http://php-apache-service.default.svc.cluster.local; done`

Monitor HPA: In another terminal, watch the HPA scaling.\
`kubectl get hpa -w`


If you want to see the top pods based on CPU.\
`kubectl top pods --sort-by cpu -A`

And to see the top pods based on memory usage.\
`kubectl top pods --sort-by memory`