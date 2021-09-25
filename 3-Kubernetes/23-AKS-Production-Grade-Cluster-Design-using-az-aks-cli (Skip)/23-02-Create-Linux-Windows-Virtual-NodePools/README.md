# Create Azure AKS Linux, Windows and Virtual Node Pools

## Step-01: Introduction
- Enable Virtual Nodes (Serverless)
- Create Linux User Node pool
- Create Windows User Node pool


## Step-02: Enable Virtual Nodes on our AKS Cluster
### Step-02-01: Enable Virtual Nodes Add-On on our AKS Cluster
```
# Verify Environment Variables
echo ${AKS_CLUSTER}, ${AKS_VNET_SUBNET_VIRTUALNODES}
```
```
# Enable Virtual Nodes on AKS Cluster
az aks enable-addons \
    --resource-group ${AKS_RESOURCE_GROUP} \
    --name ${AKS_CLUSTER} \
    --addons virtual-node \
    --subnet-name ${AKS_VNET_SUBNET_VIRTUALNODES}
```
```
# List Nodes
kubectl get nodes   
```
```
# List Virtual Nodes ACI Pods
kubectl get pods -n kube-system
```
```
# Verify Logs ACI Connector
kubectl get pods -n kube-system
```
```
kubectl -n kube-system logs -f $(kubectl get po -n kube-system | egrep -o 'aci-connector-linux-[A-Za-z0-9-]+')
```
### Step-02-02: Fix ACI Connector CrashLoopBackOff Issue
- Go to Services -> Managed Identities -> aciconnectorlinux-aksprod1
- Azure Role Assignments
    - Add Role Assignment
    - Scope: Resource Group
    - Subscription: Pay-As-You-Go
    - Resource Group: aks-prod
    - Role: Contributor
- Click on **SAVE**

### Step-02-03: Delete ACI Connector Pod to recreate it
```
# List Pods
kubectl get pods -n kube-system
```
```
# Delete aci-connector-linux pod to recreate it
kubectl -n kube-system delete pod <ACI-Connector-Pod-Name>
```
```
kubectl -n kube-system delete pod $(kubectl get po -n kube-system | egrep -o 'aci-connector-linux-[A-Za-z0-9-]+')
```
```
# List Pods (ACI Connector Pod should be running)
kubectl get pods -n kube-system
```

### Step-02-04: List Virtual Nodes and See if listed
```
# List Nodes
kubectl get nodes
```

## Step-03: Create Linux User Node Pool

### Step-03-01: Create Linux User Node Pool
```
# Create New Linux Node Pool
az aks nodepool add --resource-group ${AKS_RESOURCE_GROUP} \
                    --cluster-name ${AKS_CLUSTER} \
                    --name linux101 \
                    --node-count 1 \
                    --enable-cluster-autoscaler \
                    --max-count 5 \
                    --min-count 1 \
                    --mode User \
                    --node-vm-size Standard_DS2_v2 \
                    --os-type Linux \
                    --labels nodepool-type=user environment=production nodepoolos=linux app=java-apps \
                    --tags nodepool-type=user environment=production nodepoolos=linux app=java-apps \
                    --zones {1,2,3}

```
### Step-03-02: List Node Pools & Nodes
```
# List Node Pools
az aks nodepool list --cluster-name ${AKS_CLUSTER} --resource-group ${AKS_RESOURCE_GROUP} -o table
#Note: Understand the mode System vs User
```
```
# List Nodes using Labels
kubectl get nodes -o wide -l nodepoolos=linux
```
```
kubectl get nodes -o wide -l app=java-apps
```

## Step-04: Create a Node Pool for Windows Apps
- To run an AKS cluster that supports node pools for Windows Server containers, your cluster needs to use a network policy that uses [Azure CNI](https://docs.microsoft.com/en-us/azure/aks/concepts-network#azure-cni-advanced-networking) (advanced) network plugin
- Default windows Node size is Standard_D2s_v3 as on today
- The following limitations apply to Windows Server node pools:
  - The AKS cluster can have a maximum of 10 node pools.
  - The AKS cluster can have a maximum of 100 nodes in each node pool.
  - The Windows Server node pool name has a limit of 6 characters.

### Step-04-01: Create Windows Node Pool
```
# Create New Windows Node Pool
az aks nodepool add --resource-group ${AKS_RESOURCE_GROUP} \
                    --cluster-name ${AKS_CLUSTER} \
                    --os-type Windows \
                    --name win101 \
                    --node-count 1 \
                    --enable-cluster-autoscaler \
                    --max-count 5 \
                    --min-count 1 \
                    --mode User \
                    --node-vm-size Standard_DS2_v2 \
                    --labels environment=production nodepoolos=windows app=dotnet-apps nodepool-type=user \
                    --tags environment=production nodepoolos=windows app=dotnet-apps nodepool-type=user \
                    --zones {1,2,3}
```
### Step-04-02: List Node Pools & Nodes
```
# List Node Pools
az aks nodepool list --cluster-name ${AKS_CLUSTER} --resource-group ${AKS_RESOURCE_GROUP} --output table
```
```
# List Nodes using Labels
kubectl get nodes -o wide
```
```
kubectl get nodes -o wide -l nodepoolos=linux
```
```
kubectl get nodes -o wide -l nodepoolos=windows
```
```
kubectl get nodes -o wide -l environment=production
```

```
# List Node Pools
az aks nodepool list --cluster-name ${AKS_CLUSTER} --resource-group ${AKS_RESOURCE_GROUP} --output table
```

## References
- [Windows Node Pools](https://docs.microsoft.com/en-us/azure/aks/windows-container-cli)
