# create k8s cluster
#gcloud container clusters create --preemptible --num-nodes=1 --region=europe-west2-c --enable-basic-auth --enable-autoscaling  --max-nodes=10 hashik8s  
# get k8s credentials
gcloud container clusters get-credentials hashik8s --region=europe-west2-c
#create namespace
kubectl create ns vault-deploy
#update context with current namespace
kubectl config set-context --current --namespace=vault-deploy
# Create Helm service account and 3 local persistent volumes (dirs).
kubectl create -f serviceaccount.yaml
################################### Helm ####################################################
# init helm
helm init --service-account helm
# add kube charts 
helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
################################### Kube cockpit ####################################################
# Create Kubernetes cockpit
kubectl create -f https://raw.githubusercontent.com/cockpit-project/cockpit/master/containers/kubernetes-cockpit.json
#expose kubernetes-cockpit as LB
 kubectl expose service kubernetes-cockpit --type=LoadBalancer --port=9090 --target-port=9090 --name=kube-cockpit-external
 ################################### Consul ####################################################
kubectl create -f consulservice.yaml -n vault-deploy
kubectl create -f consulstatefulset.yaml -n vault-deploy
export secret=$(cat consul.hclic)
kubectl exec consul-0 --namespace vault-deploy -c consul -- consul license put "${secret}"
 kubectl expose service consul --type=LoadBalancer --port=8500 --target-port=8500 --name=consul-ui-external
################################### Vault ####################################################
# Provision IP Address (Replace COMPUTE_REGION and PROJECT_ID Accordingly)
#gcloud compute addresses create vault   --region=europe-west2   --project gb-playground
# Set Env Var
export VAULT_API_ADDRESS=$(gcloud compute addresses describe vault-api-address   --region europe-west2   --project gb-playground   --format=value'(address)')
# echo %VAULT_LOAD_BALANCER_IP%
# Create Vault Config Map
kubectl create configmap vault --from-literal api-addr=https://${VAULT_API_ADDRESS}:8200 --from-file=vault.hcl -n vault-deploy
kubectl create -f vaultservice.yaml -n vault-deploy
kubectl create -f vaultstatefulset.yaml -n vault-deploy
kubectl expose service vault --port=8200 --target-port=8200 --type=LoadBalancer --name=vault-external
set vaultsecret=$(cat vault.hclic)
