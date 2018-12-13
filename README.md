# Howto setup a PoC of this project

# Create Ubuntu VM & set reverse DNS
```shell
hcloud server create --image=ubuntu-18.04 --name server1 --type cx21 --ssh-key ts@treehouse-sss
hcloud server set-rdns server1 --hostname mail.example.com
```

# DNS setup part 1
Create A record to point to mail.example.com.
You probably know best how to do that with your specific setup^^

# Start bootstrap process
Login to server as root. Execute this command:

```shell
curl -L https://gitlab.e.foundation/e/infra/bootstrap/raw/master/bootstrap-mail-drive.sh | bash
```

**ATTENTION:**
You need to login to gitlab twice during this proces
(repos will be public later making the bootstrapping run unattended)

Time to reboot:
```shell
reboot
```

Tweak /mnt/docker/.env file to your needs.

# Start services
```shell
cd /mnt/docker && docker-compose up -d
```

to be continued...
