# Howto setup a PoC of this project

# Create Ubuntu VM & set reverse DNS
```shell
hcloud server create --image=ubuntu-18.04 --name server1 --type cx21 --ssh-key ts@treehouse-sss
hcloud server set-rdns server1 --hostname mail.example.com
```

# Create A record to point to mail.example.com
You probably know best how to do that with your specific setup^^

```shell
ssh root@116.203.27.23
# install stuff
apt-get update && apt install -y git && apt-get -y upgrade && apt -y autoremove
apt -y upgrade && apt -y autoremove && reboot && exit

apt -y install unattended-upgrades


# don't do this at home (aka in production) as piping from curl 2 bash is a bad idea
curl -fsSL https://get.docker.com | bash
systemctl enable docker

curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# checkout project
git -C /mnt clone https://gitlab.e.foundation/e/priv/cloud/compose.git
ln -s /mnt/compose /mnt/docker

# create folders
grep mnt docker-compose.yml  | grep -v \# | awk '{ print $2 }' | awk -F: '{ print $1 }' | sed 's@m/.*conf$@m@g' | grep -v id_rsa| sort -u | while read line; do mkdir -p "$line"; done
```
to be continued...