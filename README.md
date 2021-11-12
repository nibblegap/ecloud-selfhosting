# Ecloud Selfhosting (Beta)

This project allows users to install ecloud services on their own server, using a single identity.

This way, a user can use [/e/OS](https://e.foundation/products/) on a smartphone while self-hosting and syncing data:
 1. pictures, videos, files...
 2. calendar
 3. contacts
 4. notes
 5. tasks
 6. device configuration...

The setup, which is relying on NextCloud, Postfix, and other open source components, is very close to the one used on [ecloud.global](https://ecloud.global).

Important note: this project is currently in beta. You should have some experience with Linux server
administration if you want to use it. The current setup makes updates difficult,
so manual intervention might be necessary. In the future, we will switch to Ansible
for deployment to simplify this.

## Requirements

For the full setup, the following server hardware is recommended:

- 2 core CPU (x86/x86-64 only, ARM not supported yet)
- 4 GB RAM
- 20 GB disk space

Disk space only refers to the basic installation. You will need additional space for any emails,
documents and files you store on the server.

Additionally you will need to have a minimum of **one domain registered**. You can register a domain name from many providers.
For example (non-exhaustive list):
 - [Gandi](https://gandi.net)
 - [Hosteurope](https://hosteurope.de)
 - [Godaddy](https://godaddy.com)

Note about TLS certificates: a certificate will be added automatically during setup, using Certbot.

## Installation

### Create an Ubuntu server instance

The project should work with any Ubuntu server (Virtual Private Server (VPS), dedicated server...) version 20.04 

Debian server should work as well, though it has not been tested yet.

Suggestions include (non-exhaustive list):
 - [Hetzner](https://www.hetzner.com/cloud)
 - [Scaleway](https://scaleway.com)
 - [OVH](https://www.ovh.co.uk/vps/vps-ssd.xml)
 
Hosting at home is also possible in principle, but you will probably have problems with sending email (email providers may classify your email as spam).

First, create your hosting server. Please follow your hoster documentation to create your server or VPS.

- Please run the following commands and then reboot your server before installation:
    - `apt update`
    - `apt upgrade`

### Set your server with proper DNS settings

1. point your domain DNS entries to your server
2. then set the reverse DNS of this server to the same domain (this is usually possible in the VPS settings on the hoster's website).

The below example will use `yourdomain.com` to explain the (initial) DNS setup you need to have for this to work.

It is assumed that you your VPS is up and running, and using IPv4 address 1.2.3.4 in this example.

Create two A records in the zone file of your domain on your DNS server (or the corresponding webui of the domain registrar):
 - A record from @ -> 1.2.3.4 (@ stands for the main domain itself - but not as a placeholder in this text, literally use @!)
 - A record from mail -> 1.2.3.4 (CNAME would NOT be sufficient!)

Then set the reverse DNS of 1.2.3.4 to mail.yourdomain.com. (note the final dot '.' at the end of our fully qualified domain name). This is usually possible in the VPS settings on the hoster's website.

In the following text, `$DOMAIN` refers to the domain (`youdomain.com`) that you configured for your selfhosting server.

### Start bootstrap process

Login to the server via ssh as root (on Linux/macOS the ssh client is available out of the box, on Windows you need to use an ssh client like [Putty](https://www.putty.org/) for example).

- Please note that for Ubuntu 20.04+, you will have to add the repository for "SaltStack" using the [instructions](https://repo.saltproject.io/#ubuntu)

Execute these commands and follow the on-screen instructions:

```
$ ssh root@$DOMAIN
# git clone https://gitlab.e.foundation/e/infra/ecloud-selfhosting.git --single-branch --branch master /mnt/repo-base
# cd /mnt/repo-base
# bash scripts/bootstrap.sh
```
The setup script will ask you to input some details of your setup (like your domain name) and to setup additional DNS records (the two A records plus the PTR record were set already above).

Example session for yourdomain.com:
```
bash bootstrap.sh
[...]
Resolving deltas: 100% (681/681), done.
System update and packages installation ..
[...]
Total run time: 148.039 s
Enter your mailserver (management) domain (e.g. domainA.com):
yourdomain.com
Optionally enter additional domain(s) (comma separated, no white spaces) to handle mail for (e.g. domainB.com,domainC.com) or just press enter if you need none:

Enter alternative email:
someone@example.org
Your management domain is: yourdomain.com
Your additional domains are: [N/A]
Is this correct? (yes or no) yes
=================================================================================================================================
Please setup the following DNS records for your domains before you proceed (subsequent steps will fail if a record is missing):
=================================================================================================================================

RECORD                |  HOST                         |  VALUE                |  Priority
------                |  ----                         |  -----                |  --------
A                     |  mail.yourdomain.com          |  <Public IP>          |  -
A                     |  yourdomain.com               |  <Public IP>          |  -
MX                    |  yourdomain.com               |  mail.yourdomain.com  |  10
PTR(For reverse DNS)  |  <Public IP>                  |  mail.yourdomain.com  |  -
CNAME                 |  autoconfig.yourdomain.com    |  mail.yourdomain.com  |  -
CNAME                 |  autodiscover.yourdomain.com  |  mail.yourdomain.com  |  -
CNAME                 |  spam.yourdomain.com          |  mail.yourdomain.com  |  -
CNAME                 |  welcome.yourdomain.com       |  mail.yourdomain.com  |  -
=================================================================================================================================
=================================================================================================================================

Type 'yes' and hit ENTER to confirm that you have setup DNS properly before we continue:
yes
[...]

```

### Manual account creation

A few services can't be configured automatically and need manual account creation to secure them:

**Rainloop**: It uses a hardcoded login by default, and can be accessed by anyone with a Nextcloud account.
To change it, visit `https://$DOMAIN/apps/rainloop/app/?admin` and enter username: `admin` and password: `12345`.
Go to the security tab to change the password.

## Background job configuration

- Many background jobs(e.g. jobs run when an account is deleted) need to run for eCloud to work correctly
- In this installation, background jobs are set to use system cron and crontab for this is added
- Please follow the instructions [here](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/background_jobs_configuration.html) to change background job configuration

## Available Services

You can find login information for these services by running `bash /mnt/repo-base/scripts/showInfo.sh`.

Sample output of showInfo.sh:
```
Your password for the SPAM filter mgmt UI (https://spam.yourdomain.com) is: secret
Your admin credentials for nextcloud are (https://yourdomain.com) is:  user/password
Your credentials for postfix admin (https://mail.yourdomain.com) are:  user/password

```

- `$DOMAIN`: File hosting with [Nextcloud](https://nextcloud.com/), email with
           [rainloop](https://www.rainloop.net/)
- `welcome.$DOMAIN`: Allows users to sign up for a new account (you can create signup links with
                   `bash /mnt/repo-base/scripts/generate-signup-link.sh`, account creation with this "self service" is only possible when such a link is generated)

## Administration

- `spam.$DOMAIN`: Email spam filter ([rspamd](https://www.rspamd.com/))
- `mail.$DOMAIN`: Administrate email and create accounts ([postfixadmin](http://postfixadmin.sourceforge.net/)) when not using the "self service" `welcome.$DOMAIN` - this requires you to set a intermediate password during account creation.
- Post installation, please navigate to https://$DOMAIN/settings/admin/overview to check if there are any configuration warnings related to your installation
- Please note that we have not used http2 protocol in nginx because of nextcloud's notably [slow performance](https://github.com/nextcloud/server/issues/25297) with http2

## Privacy

- The default behaviour of nextcloud is that all users on a server can see and share with each other. As this may make sense on a company or family environment, we keep this behaviour in the  `selfhost` image tag.
- For public instances like our [ecloud](https://ecloud.global), we provide the `selfhost-privacy` tag with the enhanced privacy approach.
- Some of the improvements are:
  - Users cannot find each other on search unless they use the full email address
  - User statuses are not available globally for other users to view
  - Global contacts menu for searching contacts is disabled
- To disable group sharing and username autocompletion in the share dialog, please run the following commands on your server:
  - `docker exec -u www-data: nextcloud /var/www/html/occ config:app:set core shareapi_allow_group_sharing --value no`
  - `docker exec -u www-data: nextcloud /var/www/html/occ config:app:set core shareapi_allow_share_dialog_user_enumeration --value no`
- It is also recommended to disable the following two options under "Federated Cloud Sharing" in admin sharing settings:
  - "Search global and public address book for users"
  - "Allow users to publish their data to a global and public address book"


## Setting up /e/ OS with /e/ selfhosting

For a new installation, enter login (email address - username@yourdomain.com), password and selfhosting domain FQDN in the fist time usage wizard.

If you already have /e/ OS installed, you can add your selfhosting domain under

    Settings->Users & accounts->Add account->/e/ account

using login (email address - username@yourdomain.com), password, and specifying your custom server URL using the "Server URL" (https://yourdomain.com) field in "Login with another account":

[](https://gitlab.e.foundation/e/infra/ecloud-selfhosting/raw/1e3cb6cd56ade9d3489d30f56ea941edce4533c8/e_os_custom_server_screenshot.jpg)

![screenshot](https://gitlab.e.foundation/e/infra/ecloud-selfhosting/raw/1e3cb6cd56ade9d3489d30f56ea941edce4533c8/e_os_custom_server_screenshot.jpg)

## License

The project is licensed under [AGPL](LICENSE).

