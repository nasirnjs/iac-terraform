Update a kubeconfig file for your cluster Replace region-code with the AWS Region that your cluster Name

`aws eks --region us-east-1 update-kubeconfig --name buddy-cluster`




## Create json Policy
[cluster-auto-scaler-json Policy](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md)




## Create custom trusted role and attach policy
EKS cluster manifest file from [Here](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml)

Note:
    - registry.k8s.io/autoscaling/cluster-autoscaler:**v1.31** #change your k8s version
    - annotations:
        eks.amazonaws.com/role-arn: arn:aws:iam::xxxxx:role/Amazon_CA_role   # Add the IAM role created in  section. [Ref](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/CA_with_AWS_IAM_OIDC.md)