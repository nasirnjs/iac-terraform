Update a kubeconfig file for your cluster Replace region-code with the AWS Region that your cluster Name

`aws eks --region us-east-1 update-kubeconfig --name buddy-cluster`



## Steps 1:  Create Autoscaler Features Policy
[cluster-auto-scaler-json Policy](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md)


## Steps 2: Create custom trusted role and attach Autoscaler policy
EKS cluster manifest file from [Here](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml)


## Eid role trusted relationship Example

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

**Note:**
    - during create cluster role select your actual cluster currect oidc
    - registry.k8s.io/autoscaling/cluster-autoscaler:**v1.31** #change your k8s version
    - annotations:
        eks.amazonaws.com/role-arn: arn:aws:iam::xxxxx:role/cluster_autoscaler_role_just_now_you_created

## Apply menifest file 

`kubectl apply -f eks_cluster_autoscaler.yam`

[References](https://www.youtube.com/watch?v=__3O1Tk-26s)


# Horizontal Pod Autoscaler (HPA)
Amazon Elastic Kubernetes Service (EKS) automatically scales the number of pods in a deployment or replica set based on observed CPU/memory utilization or custom metrics. Here’s a step-by-step guide to configure HPA in an EKS cluster

Steps 1: Install Metrics Server: HPA relies on metrics like CPU and memory, which the Kubernetes Metrics Server provides. If it’s not already installed, deploy it.\
`kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml`


Steps 2: To confirm that Metrics Server is running, run the following command.\
`kubectl get pods -n kube-system -l k8s-app=metrics-server`

# Test HPA (Horizontal Pod Autoscaler)
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