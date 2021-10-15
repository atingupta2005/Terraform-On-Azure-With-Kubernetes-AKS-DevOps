# Download RStudio Server for Debian & Ubuntu
- Refer: https://www.rstudio.com/products/rstudio/download-server/debian-ubuntu/
```
sudo apt -y update
sudo apt-get -y install r-base
sudo apt-get  -y install gdebi-core
wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-2021.09.0-351-amd64.deb
sudo gdebi rstudio-server-2021.09.0-351-amd64.deb
```

- Open
  - http://<server-ip>:8787
