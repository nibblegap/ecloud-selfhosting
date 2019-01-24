#!/usr/bin/env bash
set -e

echo "Getting info from .env file"
ENVFILE="/mnt/docker/.env"

DOMAIN=$(grep ^DOMAIN= "$ENVFILE" | awk -F= '{ print $NF }')
ADD_DOMAINS=$(grep ^ADD_DOMAINS= "$ENVFILE" | awk -F= '{ print $NF }')

MYSQL_USER_NC=$(grep ^MYSQL_USER_NC= "$ENVFILE" | awk -F= '{ print $NF }')
MYSQL_PASSWORD_NC=$(grep ^MYSQL_PASSWORD_NC= "$ENVFILE" | awk -F= '{ print $NF }')
DRIVE_SMTP_PASSWORD=$(grep ^DRIVE_SMTP_PASSWORD= "$ENVFILE" | awk -F= '{ print $NF }')

PFA_SETUP_PASSWORD=$(grep ^PFA_SETUP_PASSWORD= "$ENVFILE" | awk -F= '{ print $NF }')
ALT_EMAIL=$(grep ^ALT_EMAIL= "$ENVFILE" | awk -F= '{ print $NF }')
PFA_SUPERADMIN_PASSWORD=$(grep ^PFA_SUPERADMIN_PASSWORD= "$ENVFILE" | awk -F= '{ print $NF }')

PFDB_DB=$(grep ^PFDB_DB= "$ENVFILE" | awk -F= '{ print $NF }')
PFDB_USR=$(grep ^PFDB_USR= "$ENVFILE" | awk -F= '{ print $NF }')
PFDB_DBPASS=$(grep ^DBPASS= "$ENVFILE" | awk -F= '{ print $NF }')

printf "Waiting for Nextcloud to be started"
while docker-compose exec --user www-data nextcloud php occ | grep "Nextcloud is not installed" > /dev/null;
do
    printf "."
    sleep 0.1
done

echo "Tweaking nextcloud config"
sed -i "s/localhost/drive.$DOMAIN/g" /mnt/docker/nextcloud/config/config.php
sed -i "s/);//g" /mnt/docker/nextcloud/config/config.php
/bin/echo -e "   'skeletondirectory' => '',\n   'mail_from_address' => 'drive',\n   'mail_smtpmode' => 'smtp',\n   'mail_smtpauthtype' => 'PLAIN',\n   'mail_domain' => '$DOMAIN',\n   'mail_smtpauth' => 1,\n   'mail_smtphost' => 'mail.$DOMAIN',\n   'mail_smtpname' => 'drive@$DOMAIN',\n   'mail_smtppassword' => '$DRIVE_SMTP_PASSWORD',\n   'mail_smtpport' => '587',\n   'mail_smtpsecure' => 'tls'," >> /mnt/docker/nextcloud/config/config.php
cat /mnt/docker/deployment/nc-plugin-config/user_sql_raw_config.conf | sed "s/@@@DBNAME@@@/$PFDB_DB/g" | sed "s/@@@DBUSER@@@/$PFDB_USR/g" | sed "s/@@@DBPW@@@/$PFDB_DBPASS/g" >> /mnt/docker/nextcloud/config/config.php
touch /mnt/docker/nextcloud/data/.ocdata

echo "Installing nextcloud plugin"
docker exec -ti nextcloud  su - www-data -s /bin/bash -c "php /var/www/html/occ app:install user_backend_sql_raw"
docker exec -ti nextcloud  su - www-data -s /bin/bash -c "php /var/www/html/occ upgrade"

echo "Restarting Nextcloud container"
docker restart nextcloud > /dev/null

echo "Creating postfix database schema"
curl --silent -L https://mail.$DOMAIN/setup.php > /dev/null

echo "Setting Postfix admin setup password"
docker cp /mnt/docker/deployment/postfixadmin/pwgen.php postfixadmin:/postfixadmin
SETUPPW_HASH=$(docker exec -t postfixadmin php /postfixadmin/pwgen.php "$PFA_SETUP_PASSWORD" | tail -n1)
docker exec -t postfixadmin sed -i "s|\($CONF\['setup_password'\].*=\).*|\1 '${SETUPPW_HASH}';|" /postfixadmin/config.inc.php
docker exec -t postfixadmin rm /postfixadmin/pwgen.php

echo "Adding Postfix admin superadmin account"
docker exec -t postfixadmin php /postfixadmin/scripts/postfixadmin-cli.php admin add $ALT_EMAIL --password $PFA_SUPERADMIN_PASSWORD --password2 $PFA_SUPERADMIN_PASSWORD --superadmin

echo "Adding domains to Postfix"
echo "$ADD_DOMAINS" | tr "," "\n" | while read line; do docker exec -t postfixadmin php /postfixadmin/scripts/postfixadmin-cli.php domain add $line; done

echo "Adding email accounts used by system senders (drive, ...)"
docker exec -t postfixadmin php /postfixadmin/scripts/postfixadmin-cli.php mailbox add drive@$DOMAIN --password $DRIVE_SMTP_PASSWORD --password2 $DRIVE_SMTP_PASSWORD --name "drive" --email-other $ALT_EMAIL

# display DKIM DNS setup info/instructions to the user
echo -e "\n\n\n"
echo -e "Please add the following records to your domain's DNS configuration:\n"
find /mnt/docker/mail/dkim/ -maxdepth 1 -mindepth 1 -type d | while read line; do DOMAIN=$(basename $line); echo "  - DKIM record (TXT) for $DOMAIN:" && cat $line/public.key; done

echo "================================================================================================================================="
echo "================================================================================================================================="
echo "Your logins:"
bash /mnt/repo-base/showInfo.sh

echo "================================================================================================================================="
echo "Your signup link:"
bash /mnt/repo-base/generate-signup-link.sh --user-email $ALT_EMAIL
