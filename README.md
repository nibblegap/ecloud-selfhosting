# Howto setup a PoC of this project

# Create Ubuntu VM & set reverse DNS
```shell
hcloud server create --image=ubuntu-18.04 --name server1 --type cx31 --ssh-key ts@treehouse-sss
hcloud server set-rdns server1 --hostname mail.example.com
```

# Start bootstrap process
Login to server as root. Execute this command and follow its on-screen instructions:

```shell
curl -L https://gitlab.e.foundation/thilo/bootstrap/raw/master/bootstrap-mail-drive.sh | bash
```

**ATTENTION:**
You need to login to gitlab once during this process.
(repos will be public later making the bootstrapping run unattended)

Time to reboot:
```shell
reboot
```

# Login to /e/ registry (also not necessary when going public later)
```shell
docker login registry.gitlab.e.foundation:5000
```

# Start services
```shell
cd /mnt/docker/
docker-compose -f docker-compose-autogen.yml up -d
```

# DNS/DKIM setup: launch script to get on-screen instructions on this:
```shell
bash /mnt/docker/postinstall.sh
```

# Retrieve some login information into your new system:
```shell
bash /mnt/docker/showInfo.sh
```


# postfixadmin setup
https://mail.yourdomain.tld/setup.php

insert setup pw and note done the generated hash value afterwards bring the hash into your installation by specifying it here:
```shell
docker exec -ti postfixadmin setup
```

Now you can use the setup pw to generate an admin account.

Login with the admin account here:
https://mail.yourdomain.tld/

You can now create your domains, mailboxes, alias...etc :smiley:


# setup webmail

Login to
https://webmail.domain.tld/?admin

Default login is "admin", password is "12345".

You must add and configure your domains in your admin panel like this:

![alt domains](https://camo.githubusercontent.com/a6f4ad35c115c988e4258dc857f22705b9edf0db/687474703a2f2f692e696d6775722e636f6d2f52624d56686b7a2e706e67)

SMTP/IMAP configuration:

![alt amtp/imap](https://camo.githubusercontent.com/fa9bf6188e34b4170cc9a8d8cfeba718f930dfb2/687474703a2f2f692e696d6775722e636f6d2f474662624a7a732e706e67)

SIEVE configuration:

![alt sieve](https://camo.githubusercontent.com/013beb92422e527c513d0daa12fb1ecc3f352904/687474703a2f2f692e696d6775722e636f6d2f6572764b7472472e706e67)


to be continued...
