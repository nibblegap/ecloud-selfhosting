# Ecloud Selfhosting (Beta)

This project allows users to install ecloud services on their own server, using a single identity.

This way, a user can use [/e/OS](https://e.foundation/products/) on a smartphone while self-hosting and syncing data:
 1. pictures, videos, files...
 2. calendar
 3. contacts
 4. notes
 5. tasks
 6. device configuration...

The setup, which is relying on NextCloud, OnlyOffice, Postfix, and other open source components, is very close to the one used on [ecloud.global](https://ecloud.global).

Important note: this project is currently in beta. You should have some experience with Linux server
administration if you want to use it. The current setup makes updates difficult,
so manual intervention might be necessary. In the future, we will switch to Ansible
for deployment to simplify this.

## Requirements

For the full setup, the following server hardware is recommended:

- 2 core CPU (x86/x86-64 only, ARM not supported yet)
- 4 GB RAM
- 20 GB disk space

For the setup without OnlyOffice, requirements are a bit lower:

- 1 core CPU (x86/x86-64 only, ARM not supported yet)
- 2 GB RAM
- 15 GB disk space

Disk space only refers to the basic installation. You will need additional space for any emails,
documents and files you store on the server.

## Installation

### Create an Ubuntu server instance

The project should work with any Ubuntu server (VPS, dedicated server...) versions 16.04 and 18.04. 

Debian server should work as well, though it has not been tested yet.

Suggestions include:
 - [Hetzner](https://www.hetzner.com/cloud)
 - [OVH](https://www.ovh.co.uk/vps/vps-ssd.xml)
 - [Scaleway](https://scaleway.com)
 
Hosting at home is also possible in principle, but you will probably have problems with sending email (email providers may classify your email as spam).

First, create your hosting server and point the domain to it. Then set the reverse DNS to the same domain
(this is usually possible in the VPS settings on the hoster's website).

In the following text, `$DOMAIN` refers to the domain that you configured for your selfhosting server.

### Start bootstrap process

Login to server as root. Execute this command and follow its on-screen instructions:

```
$ ssh root@$DOMAIN
# wget https://gitlab.e.foundation/e/infra/bootstrap/raw/master/bootstrap-generic.sh
# bash bootstrap-generic.sh https://gitlab.e.foundation/e/priv/infra/compose
```

### Manual account creation

A few services can't be configured automatically and need manual account creation to secure them:

**Rainloop**: It uses a hardcoded login by default, and can be accessed by anyone with a Nextcloud account.
To change it, visit `https://$DOMAIN/apps/rainloop/app/?admin` and enter username: `admin` and password: `12345`.
Go to the security tab to change the password.

**OnlyOffice**: Open `office.$DOMAIN`, then follow the instructions to add a new admin user. This
is only necessary if you chose to install OnlyOffice.

## Available Services

You can find login information for these services by running `bash /mnt/repo-base/scripts/showInfo.sh`.

- `$DOMAIN`: File hosting with [Nextcloud](https://nextcloud.com/), email with
           [rainloop](https://www.rainloop.net/)
- `welcome.$DOMAIN`: Allows users to sign up for a new account (you can create signup links with
                   `bash /mnt/repo-base/scripts/generate-signup-link.sh`)
- `office.$DOMAIN`: Create and edit office documents ([OnlyOffice](https://www.onlyoffice.com/))

## Administration

- `spam.$DOMAIN`: Email spam filter ([rspamd](https://www.rspamd.com/))
- `mail.$DOMAIN`: Administrate email and create accounts ([postfixadmin](http://postfixadmin.sourceforge.net/))

## Setting up /e/ OS with /e/ selfhosting

For a new installation, enter login (email address - username@domain), password and selfhosting domain FQDN in the fist time usage wizard.

If you already have /e/ OS installed, you can add your selfhosting domain under

    Settings->Users & accounts->Add account->/e/ account

using login (email address - username@domain), password, and specifying your custom server URL using the "Server URL" (https//domain) field in "Login with another account":

[](https://gitlab.e.foundation/e/priv/infra/ecloud-selfhosting/raw/1e3cb6cd56ade9d3489d30f56ea941edce4533c8/e_os_custom_server_screenshot.jpg)

![screenshot](https://gitlab.e.foundation/e/priv/infra/ecloud-selfhosting/raw/1e3cb6cd56ade9d3489d30f56ea941edce4533c8/e_os_custom_server_screenshot.jpg)

## License

The project is licensed under [AGPL](LICENSE).