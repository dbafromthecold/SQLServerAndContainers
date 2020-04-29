# https://microk8s.io/docs/

# start microk8s
sudo microk8s.start



# check status
microk8s.status



# check nodes
microk8s.kubectl get nodes



# run sql server in a pod
microk8s.kubectl run sqlserver \
--image=mcr.microsoft.com/mssql/server:2019-CU4-ubuntu \
--env ACCEPT_EULA=Y \
--env SA_PASSWORD=Testing1122



# check deployments
microk8s.kubectl get deployments



# check pod
microk8s.kubectl get pods



# check pod events
microk8s.kubectl describe pods



# exec into pod
microk8s.kubectl exec -it PODNAME bash



# navigate to sqlcmd
cd /opt/mssql-tools/bin/



# connect to SQL
./sqlcmd -S localhost -U sa -P Testing1122



# confirm SQL version
SELECT @@VERSION;
GO



# exit SQL and pod
exit



# expose deployment
microk8s.kubectl expose deployment sqlserver --type=ClusterIP --port=1433 --target-port=1433



# confirm service
microk8s.kubectl get service



# clean up
microk8s.kubectl delete deployment sqlserver
microk8s.kubectl delete service sqlserver



# merge microK8s config with home kubeconfig
microk8s.kubectl config view --raw > $HOME/.kube/config



# switch context to local cluser
kubectl config use-context microk8s



# confirm kubectl context
kubectl config current-context



# deploy using declarative method
kubectl create -f ~/git/SQLServerAndContainers/Yaml/sqlserver.yaml



# check deployment
kubectl get deployments



# check pods
kubectl get pods



# check service
kubectl get service



# clean up
kubectl delete deployment sqlserver
kubectl delete service sqlserver-service