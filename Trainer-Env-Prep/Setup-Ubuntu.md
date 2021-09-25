# Trainer Tasks

## Setup Shell in a Box (Access Ubuntu SSH/Shell/Console from Browser)
 - Refer: https://github.com/shellinabox/shellinabox
 - Refer: https://linoxide.com/web-remote-your-server/
```
sudo apt -y update
sudo apt -y install openssl
sudo apt -y install shellinabox
sudo /etc/init.d/shellinabox start
sudo vi /etc/default/shellinabox
  - Modify to: SHELLINABOX_ARGS="--no-beep --disable-ssl"
sudo /etc/init.d/shellinabox restart
man shellinaboxd
```
 - Open http://<ip-address>:4200
 - Note: Use Ctrl+Shift+V to paste

## Setup multiple users in Ubuntu
- For each participant, we need to setup login accounts
```
sudo groupadd docker
for ((i=1;i<=30;i++)); do
	export username="u$i"
	sudo useradd -g docker -m -p "p" $username;sudo usermod -aG sudo $username;echo $username:p | sudo /usr/sbin/chpasswd;sudo chown -R  $username:root /home/$username
done
```
