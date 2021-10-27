# .env File Documentation

In the following, `example.com` always stands for your domain that you are using with ecloud
selfhosting (ie, the domain you entered during setup).

## General configuration
```bash
DOMAIN=example.com # the main domain for your installation
ADD_DOMAINS=example.com, example2.com # one or more domains that are used for email
ALT_EMAIL=myname@some-other-domain.com # admin email address
```

## Nextcloud
```bash
NEXTCLOUD_ADMIN_USER=ncadmin_z5BL # username to login as Nextcloud admin
NEXTCLOUD_ADMIN_PASSWORD=sxOY26y0wKm1Q8SGhqmZ # password to login as Nextcloud admin
```

## Mail
```bash
RSPAMD_PASSWORD=gsteZuLgWLUNCs5b1Ksz # login to spam.example.com
PFA_SUPERADMIN_PASSWORD=1oyHLEWikVlKx0bz72 # password to create or change postfixadmin admin accounts
DISABLE_RATELIMITING=false # you can optionally disable rate limits for the mailserver
DRIVE_SMTP_PASSWORD=FL8D6SRnRWOdyMsN # password to send emails from drive@example.com
ENABLE_POP3=false # whether email retrieval via pop3 (port 110) should be enabled
VIRTUAL_HOST=autoconfig.example.com,autodiscover.example.com # additional domains for email sending/receiving
SMTP_HOST=mail.example.com # domain where the mailserver is running
```

## Database
```bash
MYSQL_USER_NC=nc_0VwU # mysql user for Nextcloud
MYSQL_PASSWORD_NC=LxsjA8bzNuzUcTYtkfof # mysql password for Nextcloud
MYSQL_DATABASE_NC=ncdb_aJWW # mysql database for Nextcloud
PFDB_DB=postfix # mysql database for postfixadmin
PFDB_USR=postfix # mysql database for postfixadmin
MYSQL_ROOT_PASSWORD=RqT9WkfrZ9e6SzX2ARoN # password for mysql root user
DBPASS=QPpTpgFkLFA2ABPizXwk # generic database password (used by multiple services)
```

## Signup
Note: To create new accounts, you need to generate an invite link with `scripts/generate-signup-link.sh` first.
```bash
VHOSTS_ACCOUNTS=welcome.example.com # domain used for signup service
SMTP_FROM=welcome@example.com # email used to send welcome message to new users
SMTP_PW=wGfQsTXPD3Ipm8Lfyk8y # password used to send welcome messages to new users
POSTFIXADMIN_SSH_PASSWORD=9uKDFMiO25AVVDhEdSnU # password used by create-account container to access postfixadmin container via ssh
CREATE_ACCOUNT_PASSWORD=sOmqLjsnLTDYw2dJPs1q # internal password needed to send requests to create-account container
```
