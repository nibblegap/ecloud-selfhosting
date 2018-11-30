# Howto setup a PoC of this project

# Create Ubuntu VM & set reverse DNS
```shell
hcloud server create --image=ubuntu-18.04 --name server1 --type cx21 --ssh-key ts@treehouse-sss
hcloud server set-rdns server1 --hostname mail.example.com
```

# Create A record to point to mail.example.com
You probably know best how to do that with your specific setup^^

Login to server as root. Execute this script (set USER to your user beforehand):

```shell
#!/bin/bash

############################################################################
# will be a parameters later
USER=thilo
BOOTSTRAPREPO=https://${USER}@gitlab.e.foundation/e/priv/cloud/compose.git
apt-get update && apt install -y --asume-yes true git salt-minion
############################################################################


# Clone repo
echo "Cloning repo .."
git -C /mnt clone $BOOTSTRAPREPO repo-base
ln -s /mnt/repo-base /mnt/docker


# Init salt-minion (masterless)
cp /mnt/repo-base/deployment/salt/init-config/masterless.conf /etc/salt/minion.d/

# Run repo init (might run a few minutes)
echo "System update and pacakges installation .."
salt-call state.apply init-repo

# Login to /e/ registry
docker login registry.gitlab.e.foundation:5000
```
You need to login to gitlab twice during this process.

Time to reboot:

```shell
reboot
```
Tweak /mnt/docker/.env file to your needs.

Run services:
```shell
cd /mnt/docker && docker-compose up -d
```

to be continued...
