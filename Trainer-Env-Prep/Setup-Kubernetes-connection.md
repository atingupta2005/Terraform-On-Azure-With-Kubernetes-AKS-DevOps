# Install kubectl
```
sudo apt -y update
sudo apt install -y curl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO https://dl.k8s.io/release/v1.22.0/bin/linux/amd64/kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
```

# Install Azure CLI
```
sudo apt -y update
sudo apt install  -y ca-certificates curl apt-transport-https lsb-release gnupg
curl -sL https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor |
    sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt -y update
sudo apt -y install azure-cli
```

# Login to Azure
```
az login
```

# Connect to Kubernetes Cluster
```
az login
az account set --subscription f13d3fd6-64e2-4bad-911e-66add3bff19a
az aks get-credentials --resource-group rgaks --name aksatin21
git clone https://github.com/atingupta2005/Terraform-On-Azure-With-Kubernetes-AKS-DevOps
```
