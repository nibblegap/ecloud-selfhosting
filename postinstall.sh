#!/usr/bin/env bash

# get info from env
ENVFILE="/mnt/docker/.env"
NEXTCLOUD_ADMIN_USER=$(grep ^NEXTCLOUD_ADMIN_USER= "$ENVFILE" | awk -F= '{ print $NF }')
NEXTCLOUD_ADMIN_PASSWORD=$(grep ^NEXTCLOUD_ADMIN_PASSWORD= "$ENVFILE" | awk -F= '{ print $NF }')
DOMAIN=$(grep ^DOMAIN= "$ENVFILE" | awk -F= '{ print $NF }')

MYSQL_USER_NC=$(grep ^MYSQL_USER_NC= "$ENVFILE" | awk -F= '{ print $NF }')
MYSQL_PASSWORD_NC=$(grep ^MYSQL_PASSWORD_NC= "$ENVFILE" | awk -F= '{ print $NF }')
DRIVE_SMTP_PASSWORD=$(grep ^DRIVE_SMTP_PASSWORD= "$ENVFILE" | awk -F= '{ print $NF }')

PFA_SETUP_PASSWORD=$(grep ^PFA_SETUP_PASSWORD= "$ENVFILE" | awk -F= '{ print $NF }')
ALT_EMAIL=$(grep ^ALT_EMAIL= "$ENVFILE" | awk -F= '{ print $NF }')
PFA_SUPERADMIN_PASSWORD=$(grep ^PFA_SUPERADMIN_PASSWORD= "$ENVFILE" | awk -F= '{ print $NF }')

# tweak nextcloud config
sed -i "s/localhost/drive.$DOMAIN/g" /mnt/docker/nextcloud/config/config.php
sed -i "s/);//g" /mnt/docker/nextcloud/config/config.php
/bin/echo -e "   'skeletondirectory' => '',\n   'mail_from_address' => 'drive',\n   'mail_smtpmode' => 'smtp',\n   'mail_smtpauthtype' => 'PLAIN',\n   'mail_domain' => '$DOMAIN',\n   'mail_smtpauth' => 1,\n   'mail_smtphost' => 'mail.$DOMAIN',\n   'mail_smtpname' => 'drive@$DOMAIN',\n   'mail_smtppassword' => '$DRIVE_SMTP_PASSWORD',\n   'mail_smtpport' => '587',\n   'mail_smtpsecure' => 'tls',\n);" >> /mnt/docker/nextcloud/config/config.php
touch /mnt/docker/nextcloud/data/.ocdata

# create admin account for nextcloud
docker cp /mnt/docker/deployment/ncdb-templates/resetpw.sh nextcloud:/tmp/ && docker exec -t nextcloud bash /tmp/resetpw.sh $NEXTCLOUD_ADMIN_USER $NEXTCLOUD_ADMIN_PASSWORD
docker restart nextcloud

# create postfix DB schema
curl --silent -L https://mail.$DOMAIN/setup.php > /dev/null

# set pfa setup password
docker cp /mnt/docker/deployment/postfixadmin/pwgen.php postfixadmin:/postfixadmin
SETUPPW_HASH=$(docker exec -t postfixadmin php /postfixadmin/pwgen.php "$PFA_SETUP_PASSWORD" | tail -n1)
docker exec -t postfixadmin sed -i "s|\($CONF\['setup_password'\].*=\).*|\1 '${SETUPPW_HASH}';|" /postfixadmin/config.inc.php
docker exec -t postfixadmin rm /postfixadmin/pwgen.php

# add pfa superadmin
docker exec -t postfixadmin php /postfixadmin/scripts/postfixadmin-cli.php admin add $ALT_EMAIL --password $PFA_SUPERADMIN_PASSWORD --password2 $PFA_SUPERADMIN_PASSWORD --superadmin

# display DKIM DNS setup info/instructions to the user
clear
echo "Please add the following records to your domain's DNS configuration."
find /mnt/docker/mail/dkim/ -maxdepth 1 -mindepth 1 -type d | while read line; do DOMAIN=$(basename $line); echo "  - DKIM record (TXT) for $DOMAIN:" && cat $line/public.key; done