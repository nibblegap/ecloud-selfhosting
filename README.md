# Ecloud Selfhosting (Beta)

This project allows you to install ecloud services on your own server. It is a similar
setup that is used on [ecloud.global](https://ecloud.global).

The project is currently in beta. You should have some experience with Linux server
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

Additionally you will need to have a minimum of one domain registered.

## Installation

### Create Ubuntu VPS

The project should work with any Ubuntu VPS. Suggestions include [Hetzner](https://www.hetzner.com/cloud)
or [OVH](https://www.ovh.co.uk/vps/vps-ssd.xml). Hosting at home is also possible in principle,
but you will probably have problems with sending email (most providers will classify your email as spam).

The below example will use `yourdomain.com` to explain the (initial) DNS setup you need to have for this to work.

TBD this is maybe a bit too technical?
First, create your VPS (note down its IP, 1.2.3.4 in this example) and create two A records in the zone file of your domain on your DNS server (or the corresponding webui of the domain registrar):
 - A record from @ -> 1.2.3.4 (@ stands for the main domain itself - but not as a placeholder in this text, literally use @!)
 - A record from mail -> 1.2.3.4 (CNAME would NOT be sufficient!)

Then set the reverse DNS of 1.2.3.4 to mail.yourdomain.com.
(this is usually possible in the VPS settings on the hoster's website).

In the following text, `$DOMAIN` refers to the domain that you configured for your selfhosting server.

### Start bootstrap process

Login to server as root. Execute this command and follow its on-screen instructions:

```
$ ssh root@$DOMAIN
# wget https://gitlab.e.foundation/e/infra/bootstrap/raw/master/bootstrap-generic.sh
# TBD this pasth will change once made public (/priv/):
# bash bootstrap-generic.sh https://gitlab.e.foundation/e/priv/infra/ecloud-selfhosting
```
The setup script will ask you to input some details of your setup (like your domain name) and to setup additional DNS records (the two A records plus the PTR record were set already above).

Example session for yourdomain.com:
```
bash bootstrap-generic.sh https://gitlab.e.foundation/e/priv/infra/ecloud-selfhosting
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
Do you want to install OnlyOffice? [y/n]
n
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

**OnlyOffice**: Open `office.$DOMAIN`, then follow the instructions to add a new admin user. This
is only necessary if you chose to install OnlyOffice.

## Available Services

You can find login information for these services by running `bash /mnt/repo-base/scripts/showInfo.sh`.

- `$DOMAIN`: File hosting with [Nextcloud](https://nextcloud.com/), email with
           [rainloop](https://www.rainloop.net/)
- `welcome.$DOMAIN`: Allows users to sign up for a new account (you can create signup links with
                   `bash /mnt/repo-base/scripts/generate-signup-link.sh`)
- `office.$DOMAIN`: Create and edit office documents ([OnlyOffice](https://www.onlyoffice.com/))
  (only when you answered yes to the question "Install OnlyOffice?" during setup obviously)

## Administration

- `spam.$DOMAIN`: Email spam filter ([rspamd](https://www.rspamd.com/))
- `mail.$DOMAIN`: Administrate email and create accounts ([postfixadmin](http://postfixadmin.sourceforge.net/))

## Setting up /e/ OS with /e/ selfhosting

For a new installation, enter the selfhosting domain in the fist time usage wizard.

If you already have /e/ OS installed, you can add your selfhosting domain under

Settings->Users & accounts->Add account->/e/ account, and specify your custom server URL using the "Server URL" field in "Login with another account":

[](https://gitlab.e.foundation/e/priv/infra/ecloud-selfhosting/raw/1e3cb6cd56ade9d3489d30f56ea941edce4533c8/e_os_custom_server_screenshot.jpg)

![screenshot](https://gitlab.e.foundation/e/priv/infra/ecloud-selfhosting/raw/1e3cb6cd56ade9d3489d30f56ea941edce4533c8/e_os_custom_server_screenshot.jpg)

## License

The project is licensed under [AGPL](LICENSE).

