## To migrate from old selfhost installation to the latest

- You can use the [diff](update-from-old-selfhost.diff) to compare and update the `docker-compose.yml` configuration
- You can also follow the steps given below to update the configuration to the latest

- Please do run the following commands before starting:
  - `cd /mnt/repo-base`
  - `docker-compose down`


### Update environment variables, folder and file locations
1. Add/Move config to new location
    - `mv /mnt/repo-base/config-static/ /mnt/repo-base/config`
    - Certstore
      - `mv /mnt/repo-base/config-dynamic/letsencrypt /mnt/repo-base/config/letsencrypt`
    - Nginx configuration
      - `mv /mnt/repo-base/config-dynamic/nginx/* /mnt/repo-base/config/nginx/`
    - Automx configuration
      - `mv /mnt/repo-base/config-dynamic/automx /mnt/repo-base/config/`
    - Nextcloud configuration
      - `mv /mnt/repo-base/config-dynamic/nextcloud /mnt/repo-base/config/nextcloud`
      - Add [x-fpm-overloads.conf](../config/nextcloud/x-fpm-overloads.conf) to `/mnt/repo-base/config/nextcloud`
      - Add [x-php-overloads.conf](../config/nextcloud/x-php-overloads.conf) to `/mnt/repo-base/config/nextcloud/`
    - Mailserver configuration
      - `mv /mnt/repo-base/config-dynamic/mail/* /mnt/repo-base/config/mail/`
    - Welcome configuration
      - Add the folder for welcome in config:
        `mkdir -p /mnt/repo-base/config/welcome/apache2`
      - Add [remoteip.conf](../config/welcome/apache2/remoteip.conf) to `/mnt/repo-base/config/apache2/`
    - Remove your OnlyOffice domain from `/mnt/repo-base/config/letsencrypt/autorenew/ssl-domains.dat`
2. Move data to new locations
    - Move mariadb data
      - `mv /mnt/repo-base/volumes/mysql/db /mnt/repo-base/volumes/mysql/db/data/`
    - Move nextcloud files
      - `mv /mnt/repo-base/volumes/nextcloud/custom_apps /mnt/repo-base/volumes/nextcloud/html/`
      - `mv /mnt/repo-base/volumes/nextcloud/config /mnt/repo-base/volumes/nextcloud/html/`
 3. Add/update required environment variables in `.env` file
    - Add a random 15 character password for `NEXTCLOUD_EMAIL_RECOVERY_APP_SECRET` in `/mnt/repo-base/.env`
      - Example entry might look like: `NEXTCLOUD_EMAIL_RECOVERY_APP_SECRET=SvezyGztu28%1fb`
    - Set `NC_HOST_IP` in `/mnt/repo-base/.env` to your server's public IP

### Update your docker-compose.yml file and configuration files for your services
1. Update `version` to  '3'
1. Networking
    - Remove the `serverbase` network entry as we move to using the `default` docker network`
    - Replace  `serverbase` with `default` in the `networks` entry for each service
1. `eelomailserver`
    - Rename the service `eelomailserver` to `mailserver`
    - Update `eelomailserver` in config to `mailserver``
      - Change `eelomailserver` in `/mnt/repo-base/config/nginx/sites-enabled/rspamd.conf` to `mailserver`
      - Update `imap_host`, `smtp_host` and `sieve_host` options in your rainloop `domain-config.ini` files to have the value `mailserver`
    - Update image from `hardware/mailserver:1.1-stable` to `mailserver2/mailserver:1.1.4`
    - Update the volume entries:
      - Remove the following volume entries:
        ```
        - /mnt/repo-base/config-dynamic/letsencrypt/certstore:/etc/letsencrypt
        - /mnt/repo-base/config-static/mail/dovecot/10-mail.conf:/etc/dovecot/conf.d/10-mail.conf
        - /mnt/repo-base/config-static/mail/dovecot/90-quota.conf:/etc/dovecot/conf.d/90-quota.conf
        - /mnt/repo-base/config-static/mail/dovecot/90-sieve.conf:/etc/dovecot/conf.d/90-sieve.conf
        - /mnt/repo-base/config-static/mail/rspamd/multimap.conf:/etc/rspamd/local.d/multimap.conf
        - /mnt/repo-base/config-static/mail/rspamd/whitelist.sender.domain.map:/etc/rspamd/local.d/whitelist.sender.domain.map
        - /mnt/repo-base/config-static/mail/rspamd/ratelimit.conf:/etc/rspamd/local.d/ratelimit.conf
        ```
      - Add the following volume entries:
        ```
        - /mnt/repo-base/config/letsencrypt/certstore:/etc/letsencrypt
        - /mnt/repo-base/config/mail/dovecot/10-mail.conf:/etc/dovecot/conf.d/10-mail.conf
        - /mnt/repo-base/config/mail/dovecot/90-quota.conf:/etc/dovecot/conf.d/90-quota.conf
        - /mnt/repo-base/config/mail/dovecot/90-sieve.conf:/etc/dovecot/conf.d/90-sieve.conf
        - /mnt/repo-base/config/mail/rspamd/multimap.conf:/etc/rspamd/local.d/multimap.conf
        - /mnt/repo-base/config/mail/rspamd/whitelist.sender.domain.map:/etc/rspamd/local.d/whitelist.sender.domain.map
        - /mnt/repo-base/config/mail/rspamd/ratelimit.conf:/etc/rspamd/local.d/ratelimit.conf
        - /mnt/repo-base/config/mail/clamav/freshclam.conf:/etc/clamav/freshclam.conf
        ```
    - Add freshclam configuration
        - Add [freshclam.conf](../config/mail/clamav/freshclam.conf) to `config/mail/clamav/`
        - Mount the file through an entry in "volumes" like `- /mnt/repo-base/config/mail/clamav/freshclam.conf:/etc/clamav/freshclam.conf`
    - Update the `.conf` files in `/mnt/repo-base/config/mail/dovecot` directory according to the `.conf` files in the [repository](../config/mail/dovecot/)
    - Update the `.conf` files in `/mnt/repo-base/config/mail/rspamd` directory according to the `.conf` files in the [repository](../config/mail/rspamd/)

1. `postfixadmin`
    - Update image to `registry.gitlab.e.foundation/e/infra/docker-postfixadmin:2.0.1`
    - Ensure that the `DRIVE_SMTP_PASSWORD` and the `DBPASS` environment variables are set in the .env file
    - Add the following environment variables to the service
        ```
        - DBHOST=mariadb
        - DRIVE_SMTP_PASSWORD=${DRIVE_SMTP_PASSWORD}
        - POSTFIXADMIN_DB_TYPE=mysqli
        - POSTFIXADMIN_DB_HOST=mariadb
        - POSTFIXADMIN_DB_USER=postfix
        - POSTFIXADMIN_DB_NAME=postfix
        - POSTFIXADMIN_DB_PASSWORD=${DBPASS}
        - POSTFIXADMIN_SMTP_SERVER=eelomailserver
        - POSTFIXADMIN_SMTP_PORT=587
        ```
    - Remove the volume entry `- /mnt/repo-base/scripts/postfixadmin-mailbox-postdeletion.sh:/usr/local/bin/postfixadmin-mailbox-postdeletion.sh` as it is bundled in the image
    - Update `eelomailserver` in `depends_on` to `mailserver`
1. `mariadb`
    - Update image to `mariadb:10.3`
    - Remove the volume entry `- /mnt/repo-base/config-dynamic/nextcloud/database:/docker-entrypoint-initdb.d`
    - Modify the db volume entry to use updated location
      - Update `- /mnt/repo-base/volumes/mysql/db:/var/lib/mysql` to `- /mnt/repo-base/volumes/mysql/db/data:/var/lib/mysql`
    - Add the [ecloud.cnf](../config/mariadb/ecloud.cnf) to `config/mariadb/` on your server
    - Add the volume entry `- /mnt/repo-base/config/mariadb/:/etc/mysql/conf.d/:ro`
1. `redis`
    - Update image to `redis:6.0-alpine`
1. `welcome`
    - Update image to `registry.gitlab.e.foundation/e/infra/docker-welcome:2.1.2`
    - Ensure that the `NEXTCLOUD_EMAIL_RECOVERY_APP_SECRET` environment variable is set correctly in the .env file
    - Ensure that the `NC_HOST_IP` environment variable is set to point to your server's IP address in the .env file
    - Add the following environment variables:
        ```
        - SMTP_PORT=587
        - NEXTCLOUD_ADMIN_USER=${NEXTCLOUD_ADMIN_USER}
        - NEXTCLOUD_ADMIN_PASSWORD=${NEXTCLOUD_ADMIN_PASSWORD}
        - NEXTCLOUD_EMAIL_RECOVERY_APP_SECRET=${NEXTCLOUD_EMAIL_RECOVERY_APP_SECRET}
        ```
    - Add the following `extra_hosts` entry:
        ```
        extra_hosts:
            - "${DOMAIN}:${NC_HOST_IP}"
        ```
1. `nextcloud`
    - Update image to `registry.gitlab.e.foundation/e/infra/ecloud/nextcloud:316db4e0`
    - Add the following environment variables:
        ```
        - MYSQL_DATABASE=${MYSQL_DATABASE_NC}
        - MYSQL_USER=${MYSQL_USER_NC}
        - MYSQL_PASSWORD=${MYSQL_PASSWORD_NC}
        - MYSQL_HOST=mariadb
        - NEXTCLOUD_ADMIN_USER=${NEXTCLOUD_ADMIN_USER}
        - OVERWRITEPROTOCOL=https
        - NEXTCLOUD_EMAIL_RECOVERY_APP_SECRET=${NEXTCLOUD_EMAIL_RECOVERY_APP_SECRET}
        ```
    - Update the `x-fpm-overloads.conf` and `x-php-overloads.ini` files in `config/nextcloud/` using the files in [config/nextcloud](../config/nextcloud/) as reference
    - Update the volume entries for the nextcloud service:
      - Remove the following volume entries:
        ```
        - /mnt/repo-base/volumes/nextcloud/custom_apps:/var/www/html/custom_apps/
        - /mnt/repo-base/volumes/nextcloud/config:/var/www/html/config/
        - /mnt/repo-base/volumes/nextcloud/data:/var/www/html/data/
        - /mnt/repo-base/config-dynamic/nextcloud/x-fpm-overloads.conf:/usr/local/etc/php-fpm.d/x-fpm-overloads.conf
        - /mnt/repo-base/config-dynamic/nextcloud/x-php-overloads.ini:/usr/local/etc/php/conf.d/x-php-overloads.ini
        - /mnt/repo-base/volumes/redis/tmp:/tmp/redis/
        ```
      - Add the following volume entries:
        ```
        - /mnt/repo-base/volumes/nextcloud/data:/var/www/data/
        - /mnt/repo-base/config/nextcloud/x-fpm-overloads.conf:/usr/local/etc/php-fpm.d/x-fpm-overloads.conf
        - /mnt/repo-base/config/nextcloud/x-php-overloads.ini:/usr/local/etc/php/conf.d/x-php-overloads.ini
        - /mnt/repo-base/volumes/nextcloud/log:/var/www/log/
        - /mnt/repo-base/volumes/redis/db:/tmp/redis
        ```
    - Update `/mnt/repo-base/volumes/nextcloud/html/config/config.php`:
      - Update `datadirectory` to have value `/var/www/data`
      - Update `logfile` to have value `/var/www/log/nextcloud.log` 
1. `create-account`: Remove the `create-account` service as it is no longer used
1. `nginx`
    - Update image to `nginx:1.19-alpine`
    - Set `restart` value to `unless-stopped`
    - Remove `create-account` from the `depends_on` entry
    - Remove `onlyoffice-community-server` from the `depends_on` entry if it exists
    - Update `eelomailserver` in `depends_on` to `mailserver`
    - Update the volume entries for the `nginx` service:
      - Remove the following volume entries:
        ```
        - /mnt/repo-base/config-dynamic/nginx/sites-enabled:/etc/nginx/conf.d/
        - /mnt/repo-base/config-static/nginx/params:/etc/nginx/params/
        - /mnt/repo-base/config-dynamic/letsencrypt/certstore:/certs
        - /mnt/repo-base/config-dynamic/nginx/passwds:/passwds
        - /mnt/repo-base/config-dynamic/letsencrypt/acme-challenge:/etc/letsencrypt/acme-challenge
        - /mnt/repo-base/volumes/nextcloud/custom_apps:/var/www/html/custom_apps/
        ```
      - Add the following volume entries:
        ```
        - /mnt/repo-base/config/nginx/sites-enabled:/etc/nginx/conf.d/
        - /mnt/repo-base/config/nginx/params:/etc/nginx/params/
        - /mnt/repo-base/config/letsencrypt/certstore:/certs
        - /mnt/repo-base/config/nginx/passwds:/passwds
        - /mnt/repo-base/config/letsencrypt/acme-challenge:/etc/letsencrypt/acme-challenge
        ```
    - Update the files in `config/nginx/params` using the files in [config/nginx/params](../config/nginx/params/) for reference
    - Update the configs in `config/nginx/sites-enabled/` using the configs in  [templates/nginx/sites-enabled](../templates/nginx/sites-enabled/) in repository for reference
1. `automx`
    - Update image to `registry.gitlab.e.foundation/e/infra/docker-mailstack:automx-0.1.0`
    - Remove volume entry `/mnt/repo-base/config-dynamic/automx/automx.conf:/etc/automx.conf`
    - Add volume entry `/mnt/repo-base/config/automx/automx.conf:/etc/automx.conf`
1. Pull, clean up and update to the latest versions
    - Run `docker system prune -a`
    - Run `docker-compose up --force-recreate -d` 
    - If you face errors with the `default` network, please retry after deleting `/var/lib/docker/network/files/local-kv.db`
