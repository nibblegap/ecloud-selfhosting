#!/usr/bin/env bash
set -e

source /mnt/repo-base/scripts/base.sh

# Create Nextcloud mysql database and user
docker-compose exec -T mariadb mysql --user=root --password="$MYSQL_ROOT_PASSWORD" \
    -e "CREATE USER '$MYSQL_USER_NC'@'%' IDENTIFIED BY '$MYSQL_PASSWORD_NC';"
docker-compose exec -T mariadb mysql --user=root --password="$MYSQL_ROOT_PASSWORD" \
    -e "CREATE DATABASE $MYSQL_DATABASE_NC DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
docker-compose exec -T mariadb mysql --user=root --password="$MYSQL_ROOT_PASSWORD" \
    -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE_NC.* TO '$MYSQL_USER_NC'@'%' WITH GRANT OPTION;"

# The maintenance:install command does not support environment variables for
# database configuration.
# https://github.com/nextcloud/server/issues/6185
docker-compose exec -T --user www-data nextcloud php occ maintenance:install \
    --admin-user="$NEXTCLOUD_ADMIN_USER" --admin-pass="$NEXTCLOUD_ADMIN_PASSWORD" \
    --admin-email="$ALT_EMAIL" --database="mysql" --database-pass="$MYSQL_PASSWORD_NC" \
    --database-name="$MYSQL_DATABASE_NC" --database-host="mariadb" --database-user="$MYSQL_USER_NC" \
    --database-port="3306" --data-dir="/var/www/data"
docker-compose exec -T --user www-data nextcloud php occ db:convert-filecache-bigint --no-interaction

# Nextcloud resets trusted_domains to localhost during installation, so we have to set it again
docker-compose exec -T --user www-data nextcloud php occ config:system:set trusted_domains 0 --value="$DOMAIN"
docker-compose exec -T --user www-data nextcloud php occ app:disable theming

# Set background jobs to use system cron
docker-compose exec -T --user www-data nextcloud php /var/www/html/occ background:cron

# add crontab on the server to run cron.php every 5 minutes
crontab -l | {
    cat
    echo "*/5 * * * * cd /mnt/repo-base && /usr/bin/docker-compose exec -T -u www-data nextcloud php -f /var/www/html/cron.php 2>&1 | /usr/bin/logger -t NC_CRON"
} | crontab -

# Update theme
docker-compose exec -T --user www-data nextcloud php /var/www/html/occ maintenance:theme:update

echo "Enabling nextcloud apps"
docker-compose exec -T --user www-data nextcloud php /var/www/html/occ app:enable calendar
docker-compose exec -T --user www-data nextcloud php /var/www/html/occ app:enable notes
docker-compose exec -T --user www-data nextcloud php /var/www/html/occ app:enable user_backend_sql_raw
docker-compose exec -T --user www-data nextcloud php /var/www/html/occ app:enable rainloop
docker-compose exec -T --user www-data nextcloud php /var/www/html/occ app:enable quota_warning
docker-compose exec -T --user www-data nextcloud php /var/www/html/occ app:enable contacts
docker-compose exec -T --user www-data nextcloud php /var/www/html/occ app:enable news
docker-compose exec -T --user www-data nextcloud php /var/www/html/occ app:enable email-recovery
docker-compose exec -T --user www-data nextcloud php /var/www/html/occ app:enable ecloud_drop_account
docker-compose exec -T --user www-data nextcloud php /var/www/html/occ app:enable ecloud-theme-helper
docker-compose exec -T --user www-data nextcloud php /var/www/html/occ app:enable ecloud-launcher
docker-compose exec -T --user www-data nextcloud php /var/www/html/occ app:disable firstrunwizard
docker-compose exec -T --user www-data nextcloud php /var/www/html/occ config:app:set rainloop rainloop-autologin --value 1
docker-compose exec -T --user www-data nextcloud php /var/www/html/occ app:install tasks
docker-compose exec -T --user www-data nextcloud php /var/www/html/occ app:install drop_account

docker-compose exec -T --user www-data nextcloud php /var/www/html/occ config:system:set integrity.check.disabled --value='true' --type=boolean

echo "Installing custom ecloud drop account plugin"
# Add WELCOME_SECRET from .env file as a system config value, to be used by our ecloud_drop_account plugin
docker-compose exec -T --user www-data nextcloud php occ config:system:set e_welcome_secret --value="$WELCOME_SECRET"
# Add VHOST_ACCOUNTS from .env file as a system config value, to be used by our ecloud_drop_account plugin
docker-compose exec -T --user www-data nextcloud php occ config:system:set e_welcome_domain --value="welcome.$DOMAIN"

# Add missing indices
docker-compose exec -T --user www-data nextcloud php /var/www/html/occ db:add-missing-indices

docker-compose exec -T --user www-data nextcloud php occ maintenance:mode --off

echo "Restarting Nextcloud container"
docker-compose restart nextcloud

echo "Configuring Rainloop"
mkdir -p "/mnt/repo-base/volumes/nextcloud/data/rainloop-storage/_data_/_default_/domains/"
echo "$ADD_DOMAINS" | tr "," "\n" | while read add_domain; do
    cp "templates/rainloop/domain-config.ini" "/mnt/repo-base/volumes/nextcloud/data/rainloop-storage/_data_/_default_/domains/$add_domain.ini"
done

mkdir "/mnt/repo-base/volumes/nextcloud/data/rainloop-storage/_data_/_default_/configs/"
cat templates/rainloop/application.ini | sed "s/@@@DOMAIN@@@/$DOMAIN/g" > "/mnt/repo-base/volumes/nextcloud/data/rainloop-storage/_data_/_default_/configs/application.ini"

chown www-data:www-data /mnt/repo-base/volumes/nextcloud/ -R

echo "Creating postfix database schema"
curl --silent -L https://mail.$DOMAIN/setup.php >/dev/null

echo "Adding Postfix admin superadmin account"
docker-compose exec -T postfixadmin /postfixadmin/scripts/postfixadmin-cli admin add $ALT_EMAIL --password $PFA_SUPERADMIN_PASSWORD --password2 $PFA_SUPERADMIN_PASSWORD --superadmin 1

# Adding domains to postfix is done by docker exec instead of docker-compose exec on purpose. Reason: with compose the loop aborts after the first item for an unknown reason
echo "Adding domains to Postfix"
# The password_expiry parameter is only a workaround, and does not have any effect
# https://github.com/postfixadmin/postfixadmin/issues/280#issuecomment-511788887
echo "$ADD_DOMAINS" | tr "," "\n" | while read line; do docker exec -t postfixadmin /postfixadmin/scripts/postfixadmin-cli domain add $line --password_expiry 0; done

echo "Adding email accounts used by system senders (drive, ...)"
docker-compose exec -T postfixadmin /postfixadmin/scripts/postfixadmin-cli mailbox add drive@$DOMAIN --password $DRIVE_SMTP_PASSWORD --password2 $DRIVE_SMTP_PASSWORD --name "drive" --email-other $ALT_EMAIL
docker-compose exec -T postfixadmin /postfixadmin/scripts/postfixadmin-cli mailbox add $SMTP_FROM --password $SMTP_PW --password2 $SMTP_PW --name "welcome" --email-other $ALT_EMAIL


echo "Setting the right domain in welcome templates"
docker-compose exec -T welcome find /var/www/html/invite_template/ -type f -exec sed -i "s/ecloud\.global/$DOMAIN/g" {} \;
docker-compose exec -T welcome find /var/www/html/invite_template/ -type f -exec sed -i "s/e\.email/$DOMAIN/g" {} \;
docker-compose exec -T welcome find /var/www/html/ -type f -name '*.html' -exec sed -i "s/e\.email/$DOMAIN/g" {} \;

# display DKIM DNS setup info/instructions to the user
echo -e "\n\n\n"
echo -e "Please add the following records to your domain's DNS configuration:\n"
find /mnt/repo-base/volumes/mail/dkim/ -maxdepth 1 -mindepth 1 -type d | while read line; do
    DOMAIN=$(basename $line)
    echo "  - DKIM record (TXT) for $DOMAIN:" && cat $line/mail.public.key
done

echo "================================================================================================================================="
echo "================================================================================================================================="
echo "Your logins:"
bash scripts/show-info.sh

echo "================================================================================================================================="
echo "Your signup link:"
bash scripts/generate-signup-link.sh --user-email $ALT_EMAIL

echo "Please reboot the server now"
