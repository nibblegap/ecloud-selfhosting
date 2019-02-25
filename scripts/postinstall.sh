#!/usr/bin/env bash
set -e

source /mnt/repo-base/scripts/base.sh

# We need to wait until both the config exists and occ works. If we only do one of these, it might
# still not work.
printf "Waiting for Nextcloud to be started"
while [ ! -f /mnt/repo-base/volumes/nextcloud/config/config.php ]
do
    printf "."
    sleep 0.1
done
while docker-compose exec --user www-data nextcloud php occ | grep -q "Nextcloud is not installed";
do
    printf "."
    sleep 0.1
done

echo "Tweaking nextcloud config"
sed -i "s/localhost/drive.$DOMAIN/g" /mnt/repo-base/volumes/nextcloud/config/config.php
sed -i "s/);//g" /mnt/repo-base/volumes/nextcloud/config/config.php
/bin/echo -e "   'skeletondirectory' => '',\n   'mail_from_address' => 'drive',\n   'mail_smtpmode' => 'smtp',\n   'mail_smtpauthtype' => 'PLAIN',\n   'mail_domain' => '$DOMAIN',\n   'mail_smtpauth' => 1,\n   'mail_smtphost' => 'mail.$DOMAIN',\n   'mail_smtpname' => 'drive@$DOMAIN',\n   'mail_smtppassword' => '$DRIVE_SMTP_PASSWORD',\n   'mail_smtpport' => '587',\n   'mail_smtpsecure' => 'tls'," >> /mnt/repo-base/volumes/nextcloud/config/config.php
cat /mnt/repo-base/templates/nextcloud/plugin-config/user_sql_raw_config.conf | sed "s/@@@DBNAME@@@/$PFDB_DB/g" | sed "s/@@@DBUSER@@@/$PFDB_USR/g" | sed "s/@@@DBPW@@@/$PFDB_DBPASS/g" >> /mnt/repo-base/volumes/nextcloud/config/config.php
touch /mnt/repo-base/volumes/nextcloud/data/.ocdata

echo "Installing nextcloud plugin"
docker-compose exec --user www-data nextcloud php /var/www/html/occ app:install user_backend_sql_raw
docker-compose exec --user www-data nextcloud php /var/www/html/occ  upgrade

echo "Restarting Nextcloud container"
docker-compose restart nextcloud

echo "Creating postfix database schema"
curl --silent -L https://mail.$DOMAIN/setup.php > /dev/null

echo "Setting Postfix admin setup password"
docker cp /mnt/repo-base/deployment/postfixadmin/pwgen.php postfixadmin:/postfixadmin
SETUPPW_HASH=$(docker-compose exec postfixadmin php /postfixadmin/pwgen.php "$PFA_SETUP_PASSWORD" | tail -n1)
docker-compose exec postfixadmin sed -i "s|\($CONF\['setup_password'\].*=\).*|\1 '${SETUPPW_HASH}';|" /postfixadmin/config.inc.php
docker-compose exec postfixadmin rm /postfixadmin/pwgen.php

echo "Adding Postfix admin superadmin account"
docker-compose exec postfixadmin php /postfixadmin/scripts/postfixadmin-cli.php admin add $ALT_EMAIL --password $PFA_SUPERADMIN_PASSWORD --password2 $PFA_SUPERADMIN_PASSWORD --superadmin

echo "Adding domains to Postfix"
echo "$ADD_DOMAINS" | tr "," "\n" | while read line; do docker-compose exec postfixadmin php /postfixadmin/scripts/postfixadmin-cli.php domain add $line; done

echo "Adding email accounts used by system senders (drive, ...)"
docker-compose exec postfixadmin php /postfixadmin/scripts/postfixadmin-cli.php mailbox add drive@$DOMAIN --password $DRIVE_SMTP_PASSWORD --password2 $DRIVE_SMTP_PASSWORD --name "drive" --email-other $ALT_EMAIL

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
