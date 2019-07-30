# Requirements

For the full setup, the following server hardware is recommended:

- 2 core CPU (x86/x86-64 only, ARM not supported yet)
- 4 GB RAM
- 20 GB disk space

For the setup without OnlyOffice, requirements are a bit lower:

- 1 core CPU
- 2 GB RAM
- 15 GB disk space

Disk space only refers to the basic installation. You will need additional space for any emails,
documents and files you store on the server.

### Required packages (these should be included with Ubuntu by default)
- curl
- bash

# Installation

## Create Ubuntu VM & set reverse DNS
This examplpes uses Hetzner cloud (sorry Gael ;)).
You can use whatever provider you want. Just make sure to set rdns correctly before running the
bootstrap script (works via Webui with some other hosters)
```
$ hcloud server create --image=ubuntu-18.04 --name server1 --type cx31 --ssh-key ts@treehouse-sss
$ hcloud server set-rdns server1 --hostname mail.example.com
```

### Start bootstrap process
Login to server as root. Execute this command and follow its on-screen instructions:

```
# wget https://gitlab.e.foundation/e/infra/bootstrap/raw/master/bootstrap-generic.sh
# bash bootstrap-generic.sh https://gitlab.e.foundation/e/priv/infra/compose
```

**ATTENTION:**
You need to login to gitlab once during this step.
(repos will be public later making the bootstrapping run unattended)

# Available Services

You can find login information for these services by running `showInfo.sh`.

- $DOMAIN: File hosting with [Nextcloud](https://nextcloud.com/), email with
           [rainloop.net](https://www.rainloop.net/)
- welcome.$DOMAIN: Allows users to sign up for a new account (you can create signup links with
                   `bash /mnt/repo-base/scripts/generate-signup-link.sh`)
- office.$DOMAIN: Create and edit office documents ([onlyoffice.com](https://www.onlyoffice.com/))

# Administration

- spam.$DOMAIN: Email spam filter ([rspamd.com](https://www.rspamd.com/))
- mail.$DOMAIN: Administrate email and create accounts ([postfixadmin.sourceforge.net](http://postfixadmin.sourceforge.net/))

