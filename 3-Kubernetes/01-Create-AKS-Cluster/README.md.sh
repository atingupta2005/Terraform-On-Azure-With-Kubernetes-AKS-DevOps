# Create AKS Cluster

## Step-01: Introduction
- Understand about AKS Cluster
- Discuss about Kubernetes Architecture from AKS Cluster perspective

## Step-02: Create AKS Cluster
- Create Kubernetes Cluster
- **Basics**
  - **Resource Group:** Create New: aks-rg-<yourname>
  - **Kubernetes Cluster Name:** aksdemo-<yourname>
  - **Region:** <Your Region>
  - **Node Count:** 1
- **Authentication**
  - Authentication method: 	System-assigned managed identity
- **Networking**
  - **Network Configuration:** Azure CNI
  - **Network Policy:** Azure
- **Integrations**
  - Azure Container Registry: None
- **Review + Create**
  - Click on **Create**

## Create AKS Cluster using Azure CLI
- Open Azure Clout Shell
- Set the value in myName

myName="ating"
mylocation="eastus2"
echo $myName $mylocation


- Create Resource Group

az group create --name "rg-$myName-aks-cluster" --location $mylocation


- Create AKS Cluster

az aks create --resource-group "rg-$myName-aks-cluster" --name "$myName-AKSCluster" --node-count 1  --load-balancer-sku basic --node-vm-size Standard_B2s --network-plugin azure  --enable-managed-identity  --generate-ssh-keys --location $mylocation


- Enable Virtual Nodes in AKS

az aks enable-addons --addons virtual-node --name  "$myName-AKSCluster" --resource-group "rg-$myName-aks-cluster" --subnet "subnet-virtual-nodes"



- Delete AKS Cluster

myName="ating"
mylocation="westus2"
az aks stop --name "$myName-AKSCluster"  --resource-group "rg-$myName-aks-cluster"
az aks delete --name "$myName-AKSCluster"  --resource-group "rg-$myName-aks-cluster"
az group delete -n "$myName-AKSCluster"
az group delete -n mc_rg-$myName-aks-cluster_$myName-AKSCluster_$mylocation


## Step-03: Cloud Shell - Configure kubectl to connect to AKS Cluster

- Go to https://shell.azure.com

az login


az aks get-credentials --resource-group aks-rg-<your-name> --name aksdemo-<your-name>


# List Kubernetes Worker Nodes
kubectl get nodes


kubectl get nodes -o wide


## Step-04: Explore Cluster Control Plane and Workload inside that

# List Namespaces
kubectl get namespaces


# List Pods from all namespaces
kubectl get pods --all-namespaces


# List all k8s objects from Cluster Control plane
kubectl get all --all-namespaces


## Step-05: Explore the AKS cluster on Azure Management Console
- **Overview**
  - Activity Log
  - Access Control (IAM)
  - Security
- **Settings**
  - Node Pools
  - Upgrade
  - Scale
  - Networking
- **Monitoring**
  - Insights
  - Alerts
  - Metrics
- **VM Scale Sets**
  - Verify Azure VM Instances

## Step-06: Desktop - Install Azure CLI and Azure AKS CLI (If Required)

# Login to Azure
az login


# Install Azure AKS CLI
az aks install-cli


# Configure Cluster Creds (kube config)
az aks get-credentials --resource-group aks-rg-<your-name> --name aksdemo-<your-name>


# List AKS Nodes
kubectl get nodes
kubectl get nodes -o wide

## Step-07: Deploy Sample Application and Test

# Deploy Application
kubectl apply -f kube-manifests/


# Verify Pods
kubectl get pods


# Verify Deployment
kubectl get deployment


# Verify Service (Make a note of external ip)
kubectl get service


# Access Application
curl    <External-IP-from-get-service-output>


## Step-07: Clean-Up

# Delete Applications
kubectl delete -f kube-manifests/


## References
- https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-macos?view=azure-cli-latest
