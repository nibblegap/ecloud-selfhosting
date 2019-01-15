# Requirements

For the full setup, the following server hardware is recommended:

- 2 core CPU
- 4 GB RAM
- 20 GB disk space

For the setup without OnlyOffice, requirements are a bit lower:

- 1 core CPU
- 2 GB RAM
- 15 GB disk space

Disk space only refers to the basic installation. You will need additional space for any emails, documents and files you store on the server.

### Required packages (these should be included with Ubuntu by default)
- curl
- bash

# Installation

## Create Ubuntu VM & set reverse DNS
This examplpes uses Hetzner cloud (sorry Gael ;)).
You can use whatever provider you want. Just make sure to set rdns correctly before running the bootstrap script (works via Webui with some other hosters)
```shell
$ hcloud server create --image=ubuntu-18.04 --name server1 --type cx31 --ssh-key ts@treehouse-sss
$ hcloud server set-rdns server1 --hostname mail.example.com
```

### Start bootstrap process
Login to server as root. Execute this command and follow its on-screen instructions:

```shell
# curl -L https://gitlab.e.foundation/e/infra/bootstrap/raw/master/bootstrap-mail-drive.sh | bash
```

**ATTENTION:**
You need to login to gitlab once during this process.
(repos will be public later making the bootstrapping run unattended)

Time to reboot:
```shell
# reboot now
```

### Login to /e/ registry (also not necessary when going public later)
```shell
# docker login registry.gitlab.e.foundation:5000
```

### Start services
```shell
# cd /mnt/docker/
# docker-compose up -d
```

### DNS/DKIM setup: launch script to get on-screen instructions on this:
```shell
# bash /mnt/docker/postinstall.sh
```

### Retrieve some login information into your new system:
```shell
# bash /mnt/docker/showInfo.sh
```

# Available Services

You can find login information for these services by running `showInfo.sh`.

- welcome.$DOMAIN: Allows users to sign up for a new account, which will work for all of the following services
- webmail.$DOMAIN: Send and receive emails ([rainloop.net](https://www.rainloop.net/))
- drive.$DOMAIN: File hosting ([nextcloud.com](https://nextcloud.com/))
- office.$DOMAIN: Create and edit office documents ([onlyoffice.com](https://www.onlyoffice.com/))

# Administration

- spam.$DOMAIN: Email spam filter ([rspamd.com](https://www.rspamd.com/))
- dba.$DOMAIN: Database administration ([phpmyadmin.net](https://www.phpmyadmin.net/))
- mail.$DOMAIN: Administrate email and create accounts ([postfixadmin.sourceforge.net](http://postfixadmin.sourceforge.net/))

