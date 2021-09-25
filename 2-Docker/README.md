# Setup Docker
```
#sudo apt-get remove -y docker docker-ce-cli docker-ce docker-engine docker.io containerd runc
```
```
#curl -fsSL get.docker.com -o get-docker.sh
```
```
#sh get-docker.sh
```
```
#sudo usermod -aG docker $USER
```

- Now should logout and login again
```
docker version
```

# Creating and Using Containers
## Starting a Nginx Web Server
```
docker container run --publish 81:80 --detach nginx
```
```
curl localhost:81
```
```
docker container ls
```
```
docker container stop 690
```
```
docker container ls
```
```
docker container ls -a
```
```
docker container run --publish 82:80 --detach --name webhost nginx
```
```
curl localhost:82
```
```
docker container ls -a
```
```
docker container logs webhost
```
```
docker container rm 63f 690 ode
```
```
docker container ls -a
```
## Getting a Shell Inside Containers - Open Terminal
```
docker container run -it --name proxy nginx bash
```
```
docker container ls
```
```
docker container ls -a
```
```
docker container run -it --name ubuntu ubuntu
```
```
exit
```

```
docker container ls
```
```
docker container ls -a
```
```
docker container start -ai ubuntu
```
```
exit
```
```
docker container exec -it mysql bash
```
```
exit
```

```
docker container ls
```
```
docker pull alpine
```
```
docker image ls
```
```
docker container run -it alpine sh
```
```
exit
```

## Container Images

### Create Docker Hub account:
- http://hub.docker.com

### Pull image from Dockerhub
```
docker image ls
```
```
docker pull nginx
```
```
docker image ls
```

### Image Tagging and Pushing to Docker Hub
```
docker image ls
```
```
docker pull mysql/mysql-server
```
```
docker image ls
```
```
docker pull nginx:mainline
```
```
docker image ls
```
```
docker image tag nginx atingupta2005/nginx
```
```
docker image ls
```
```
docker login
```
```
docker image push atingupta2005/nginx
```
```
docker image ls
```

### Building Images: The Dockerfile Basics
```
cd dockerfile-sample-1
```
```
cat Dockerfile
```

### Building Images: Running Docker Builds
```
docker image build -t customnginx .
```
```
docker image ls
```
```
docker image build -t customnginx .
```
```
docker container run -p 89:80 --name customnginx_host -d customnginx
```

```
curl localhost:89
```

```
cd..
```
