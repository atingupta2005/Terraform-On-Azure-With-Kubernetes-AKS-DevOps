# Create AKS Cluster

## Step-01: Introduction
- Understand about AKS Cluster
- Discuss about Kubernetes Architecture from AKS Cluster perspective
  - [00-Slides](00-Slides)

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
  - **Network Configuration:** Advanced
  - **Network Policy:** Azure
- **Integrations**
  - Azure Container Registry: None
- **Review + Create**
  - Click on **Create**


## Step-03: Cloud Shell - Configure kubectl to connect to AKS Cluster
- Go to https://shell.azure.com
```
# Template
az aks get-credentials --resource-group <Resource-Group-Name> --name <Cluster-Name>

# List Kubernetes Worker Nodes
kubectl get nodes
kubectl get nodes -o wide
```

## Step-04: Explore Cluster Control Plane and Workload inside that
```
# List Namespaces
kubectl get namespaces
kubectl get ns

# List Pods from all namespaces
kubectl get pods --all-namespaces

# List all k8s objects from Cluster Control plane
kubectl get all --all-namespaces
```

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

## Step-06: Desktop - Install Azure CLI and Azure AKS CLI
```
# Login to Azure
az login

# Install Azure AKS CLI
az aks install-cli

# Configure Cluster Creds (kube config)
az aks get-credentials --resource-group <> --name <>

# List AKS Nodes
kubectl get nodes
kubectl get nodes -o wide
```
## Step-07: Deploy Sample Application and Test
```
# Deploy Application
kubectl apply -f kube-manifests/

# Verify Pods
kubectl get pods

# Verify Deployment
kubectl get deployment

# Verify Service (Make a note of external ip)
kubectl get service

# Access Application
http://<External-IP-from-get-service-output>
```

## Step-07: Clean-Up
```
# Delete Applications
kubectl delete -f kube-manifests/
```

## References
- https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-macos?view=azure-cli-latest
