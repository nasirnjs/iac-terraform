kubectl create ns prometheus

# Add helm repositories for Prometheus
helm repo add kube-state-metrics https://kubernetes.github.io/kube-state-metrics
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm upgrade -i prometheus prometheus-community/prometheus \
  --namespace prometheus \
  --set alertmanager.persistentVolume.storageClass="gp2",
  --server.persistentVolume.storageClass="gp2"



helm install grafana grafana/grafana \
  --namespace grafana \
  --set persistence.storageClassName="gp2" \
  --set persistence.enabled=true
  --set adminPassword='Strong4@Password' \
  --values grapana.yaml \
  --set service.type=NodePort



  https://medium.com/@jayvardhanchandel/monitoring-eks-cluster-with-prometheus-and-grafana-a5576301e71b


  helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
--set clusterName=buddy-cluster \
--set vpcId=vpc-0f590c09823b080ac \
--set serviceAccount.create=true \
--set serviceAccount.name=alb-ingress-controller \
--set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"="arn:aws:iam::699475925713:role/alb_controller_role" \
--namespace kube-system


helm install grafana grafana/grafana \
    --namespace grafana \
    --set persistence.storageClassName="gp2" \
    --set persistence.enabled=true
    --set adminPassword='Strong4@Password' \
    --values grapana.yaml \
    --set service.type=NodePort
    
    
    
    graps.cloudopsschool.comhelm upgrade -i grafana grafana/grafana \
  --namespace grafana \
  --set persistence.storageClassName="gp2" \
  --set persistence.enabled=true
