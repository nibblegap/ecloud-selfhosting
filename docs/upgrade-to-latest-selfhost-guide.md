## To migrate from old selfhost installation to the latest

- You can use the [diff](update-from-old-selfhost.diff) to compare and update the `docker-compose.yml` configuration
- You can also follow the steps given below to update the configuration to the latest(Note that volume locations and service names are not changed but old ones are used in the steps given below)

### Update your docker-compose.yml file and configuration files for your services
1. Run `docker-compose down` to stop all services before upgrading
1. Update `version` to  '3'
1. Networking
    - Remove the `serverbase` network entry as we move to using the `default` docker network`
    - Replace  `serverbase` with `default` in the `networks` entry for each service
1. `eelomailserver`
    - Update image from `hardware/mailserver:1.1-stable` to `mailserver2/mailserver:1.1.4`
    - Add freshclam configuration
        - Add [freshclam.conf](../config/mail/clamav/freshclam.conf) to "config-static/mail/clamav/"
        - Mount the file through an entry in "volumes" like `- /mnt/repo-base/config-static/mail/clamav/freshclam.conf:/etc/clamav/freshclam.conf`
    - Update the `.conf` files in `config-static/mail/dovecot` directory according to the `.conf` files in the [repository](../config/mail/dovecot/)
    - Update the `.conf` files in `config-static/mail/rspamd` directory according to the `.conf` files in the [repository](../config/mail/rspamd/)

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
1. `mariadb`
    - Update image to `mariadb:10.3`
    - Remove the volume entry `- /mnt/repo-base/config-dynamic/nextcloud/database:/docker-entrypoint-initdb.d`
    - Add the [ecloud.cnf](../config/mariadb/ecloud.cnf) to `config-static/mariadb/` on your server
    - Add the volume entry `- /mnt/repo-base/config-static/mariadb/:/etc/mysql/conf.d/:ro`
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
    - Update the `x-fpm-overloads.conf` and `x-php-overloads.ini` files in `config-static/nextcloud/` using the files in [config/nextcloud](../config/nextcloud/) as reference
1. `create-account`: Remove the `create-account` service as it is no longer used
1. `nginx`
    - Update image to `nginx:1.19-alpine`
    - Set `restart` value to `unless-stopped`
    - Remove `create-account` from the `depends_on` entry
    - Update the files in `config-static/nginx/params` using the files in [config/nginx/params](../config/nginx/params/) for reference
    - Update the configs in `config-dynamic/nginx/sites-enabled/` using the configs in  [templates/nginx/sites-enabled](../templates/nginx/sites-enabled/) in repository for reference
1. Pull and update the latest versions
    - Run `docker-compose pull`
    - Run `docker-compose up --force-recreate -d` 