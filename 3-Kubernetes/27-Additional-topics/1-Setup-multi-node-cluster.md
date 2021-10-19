# Install 3 Node K8S Clister on Ubuntu 18.0.4 LTS

## Install Master: Dependencies
- Diable swap
```
sudo vi /etc/fstab
```

```
sudo apt update && sudo apt upgrade -y
```

```
sudo curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
```

```
sudo apt install linux-image-extra-virtual ca-certificates curl software-properties-common -y
```

```
sudo apt-get  -y update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get -y update
sudo apt-get -y  install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```

```
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

```
sudo add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
```

```
sudo apt update
```

## Master: Install Docker, Kubernetnes
```
sudo apt install docker.io kubelet kubeadm kubectl kubernetes-cni -y
```

## Master: Initialize the Kubernetes Cluster:
- Update your network card info here - ours are ens160 and specifiy your IP address -- 172.16.3.28

```
kubeadm init --pod-network-cidr 192.168.0.0/16 --service-cidr 10.96.0.0/12 --service-dns-domain "k8s" --apiserver-advertise-address 172.16.3.28
```

- You should get information back on initiating commands as a normal user, as well as the network that you need to deploy as well as how to join worker nodes to the cluster.

## Master: Setup the Kubernetes Config:

- As a normal user:

```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
export KUBECONFIG=$HOME/.kube/config
export KUBECONFIG=$HOME/.kube/config | tee -a ~/.bashrc
```

## Master: Deploy a POD Network to the Cluster:
- As a normal user, deploy a pod network: Our version:
```
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.3.0/weave-daemonset-k8s-1.7.yaml
```

## Worker: Setup Dependencies and Install Kubernetes:
```
sudo apt update && sudo apt upgrade -y
sudo curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
```

```
sudo cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
```

```
sudo apt-get update
sudo apt install linux-image-extra-virtual ca-certificates curl software-properties-common -y
```

```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

```
add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
```

```
sudo apt update
sudo apt install docker.io kubelet kubeadm kubectl kubernetes-cni -y
```


## Worker: Setup the Kubernetes Config:
- As a normal user:
```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
export KUBECONFIG=$HOME/.kube/config
export KUBECONFIG=$HOME/.kube/config | tee -a ~/.bashrc
```


## Worker: Join the Node to the Cluster:
- From the output of the kubeadm init, you received a join token, which we will be running from the node that we would like to join:
```
kubeadm join --token 51e20a.40a4599dbe3ca2e0 172.31.39.193:6443 --discovery-token-ca-cert-hash sha256:[long-string]
```

## Master: Check if the nodes are reachable:
```
kubectl get nodes
```

#NAME               STATUS    ROLES     AGE       VERSION
#ip-172-31-32-88    Ready     <none>    16m       v1.8.4
#ip-172-31-39-193   Ready     master    23m       v1.8.4



## Master: Verify if all the Kube-System Containers are running:
```
kubectl get all --namespace=kube-system
```

## Master: List the Pods:
- List the containers thats currently running:
```
kubectl get pods
```
#NAME                     READY     STATUS              RESTARTS   AGE
#guids-6d7b75568d-sndbd   0/1       ContainerCreating   0          5s


# Master: Deploy a Pod:
- Lets deploy a service into our kubernetes cluster:

kubectl run guids --image=alexellis2/guid-service:latest --port 9000

#deployment "guids" created

kubectl get pods

#NAME                     READY     STATUS    RESTARTS   AGE
#guids-6d7b75568d-sndbd   1/1       Running   0          15s

# Master: Describe the Pod:
- Describe the Pod and get the IP:

kubectl describe pod guids-6d7b75568d-sndbd | grep IP
#IP:             192.168.144.66



# Master: Describing Services:
kubectl describe services kubernetes-dashboard --namespace=kube-system

# Master: Testing the Service:
curl 192.168.144.66:9000/guid
#{"guid":"dde5c4f1-d412-4acf-9ab3-bd81b347bc4f","container":"guids-6d7b75568d-sndbd"}

# Master: Getting the Logs:
kubectl logs guids-6d7b75568d-sndbd


# Master: Exec into a Cointainer:
kubectl exec -it guids-6d7b75568d-sndbd sh

# Create the Dashboard Service:
kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
kubectl describe services kubernetes-dashboard --namespace=kube-system
kubectl proxy --address 0.0.0.0 --port 8001 --accept-hosts='^*$'

#or if using localhost:
ssh -L 8001:127.0.0.1:8001 -N


# Deploy a Web Application:
kubectl create namespace sock-shop
kubectl apply -n sock-shop -f "https://github.com/microservices-demo/microservices-demo/blob/master/deploy/kubernetes/complete-demo.yaml?raw=true"
kubectl -n sock-shop get svc front-end
kubectl get pods --namespace=sock-shop




## Resources:
- https://github.com/kubernetes/kubernetes/tree/master/examples
- http://blog.pichuang.com.tw/Installing-Kubernetes-on-Linux-with-kubeadm/
- https://blog.alexellis.io/kubernetes-in-10-minutes/
- http://alexander.holbreich.org/kubernetes-on-ubuntu/
- http://alesnosek.com/blog/2017/02/14/accessing-kubernetes-pods-from-outside-of-the-cluster/


## Installing Helm 
https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get
- Save this into a helm-install.sh fsudo helm initile and chmod +x it.
- Run with sudo priv: sudo helm-install.sh
- sudo helm init

## Perform this setting on all nodes:
sudo sysctl -w vm.max_map_count=262144

http://dougbtv.com/nfvpe/2017/06/02/istio/ -- Installing the itsioctl

