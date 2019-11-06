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
    --database-port="3306" --database-table-prefix=""
docker-compose exec -T --user www-data nextcloud php occ db:convert-filecache-bigint --no-interaction

# Nextcloud resets trusted_domains to localhost during installation, so we have to set it again
docker-compose exec -T --user www-data nextcloud php occ config:system:set trusted_domains 0 --value="$DOMAIN"

echo "Installing nextcloud plugins"
docker-compose exec -T --user www-data nextcloud php /var/www/html/occ app:install calendar
docker-compose exec -T --user www-data nextcloud php /var/www/html/occ app:install tasks
docker-compose exec -T --user www-data nextcloud php /var/www/html/occ app:install notes
docker-compose exec -T --user www-data nextcloud php /var/www/html/occ app:install user_backend_sql_raw
docker-compose exec -T --user www-data nextcloud php /var/www/html/occ app:install rainloop
docker-compose exec -T --user www-data nextcloud php /var/www/html/occ config:app:set rainloop rainloop-autologin --value 1

echo "Installing Nextcloud theme"
wget "https://gitlab.e.foundation/api/v4/projects/315/repository/archive.tar.gz" -O "/tmp/nextcloud-theme.tar.gz"
tar -xzf "/tmp/nextcloud-theme.tar.gz" -C "volumes/nextcloud/html/themes/" --strip-components=1
chown www-data:www-data "volumes/nextcloud/html/themes/" -R
rm "/tmp/nextcloud-theme.tar.gz"

docker-compose exec -T --user www-data nextcloud php /var/www/html/occ config:system:set theme --value eelo

docker-compose exec -T --user www-data nextcloud php occ maintenance:mode --off

echo "Restarting Nextcloud container"
docker-compose restart nextcloud

echo "Configuring Rainloop"
mkdir -p "/mnt/repo-base/volumes/nextcloud/data/rainloop-storage/_data_/_default_/domains/"
echo "$ADD_DOMAINS" | tr "," "\n" | while read add_domain; do
    cp "templates/rainloop/domain-config.ini" "/mnt/repo-base/volumes/nextcloud/data/rainloop-storage/_data_/_default_/domains/$add_domain.ini"
done
chown www-data:www-data /mnt/repo-base/volumes/nextcloud/ -R

echo "Creating postfix database schema"
curl --silent -L https://mail.$DOMAIN/setup.php > /dev/null

echo "Adding Postfix admin superadmin account"
docker-compose exec -T postfixadmin /postfixadmin/scripts/postfixadmin-cli admin add $ALT_EMAIL --password $PFA_SUPERADMIN_PASSWORD --password2 $PFA_SUPERADMIN_PASSWORD --superadmin

# Adding domains to postfix is done by docker exec instead of docker-compose exec on purpose. Reason: with compose the loop aborts after the first item for an unknown reason
echo "Adding domains to Postfix"
# The password_expiry parameter is only a workaround, and does not have any effect
# https://github.com/postfixadmin/postfixadmin/issues/280#issuecomment-511788887
echo "$ADD_DOMAINS" | tr "," "\n" | while read line; do docker exec -t postfixadmin /postfixadmin/scripts/postfixadmin-cli domain add $line --password_expiry 0; done

echo "Adding email accounts used by system senders (drive, ...)"
docker-compose exec -T postfixadmin /postfixadmin/scripts/postfixadmin-cli mailbox add drive@$DOMAIN --password $DRIVE_SMTP_PASSWORD --password2 $DRIVE_SMTP_PASSWORD --name "drive" --email-other $ALT_EMAIL
docker-compose exec -T postfixadmin /postfixadmin/scripts/postfixadmin-cli mailbox add $SMTP_FROM --password $SMTP_PW --password2 $SMTP_PW --name "welcome" --email-other $ALT_EMAIL

# display DKIM DNS setup info/instructions to the user
echo -e "\n\n\n"
echo -e "Please add the following records to your domain's DNS configuration:\n"
find /mnt/repo-base/volumes/mail/dkim/ -maxdepth 1 -mindepth 1 -type d | while read line; do DOMAIN=$(basename $line); echo "  - DKIM record (TXT) for $DOMAIN:" && cat $line/public.key; done

echo "================================================================================================================================="
echo "================================================================================================================================="
echo "Your logins:"
bash scripts/show-info.sh

echo "================================================================================================================================="
echo "Your signup link:"
bash scripts/generate-signup-link.sh --user-email $ALT_EMAIL

echo "Please reboot the server now"
