#!/usr/bin/env bash

ENVFILE="/mnt/docker/.env"
NEXTCLOUD_ADMIN_USER=$(grep ^NEXTCLOUD_ADMIN_USER= "$ENVFILE" | awk -F= '{ print $NF }')
NEXTCLOUD_ADMIN_PASSWORD=$(grep ^NEXTCLOUD_ADMIN_PASSWORD= "$ENVFILE" | awk -F= '{ print $NF }')
DOMAIN=$(grep ^DOMAIN= "$ENVFILE" | awk -F= '{ print $NF }')

MYSQL_USER_NC=$(grep ^MYSQL_USER_NC= "$ENVFILE" | awk -F= '{ print $NF }')
MYSQL_PASSWORD_NC=$(grep ^MYSQL_PASSWORD_NC= "$ENVFILE" | awk -F= '{ print $NF }')

sed -i "s/'localhost'/'drive.$DOMAIN'/g" /mnt/docker/nextcloud/config/config.php
sed -i "s/);//g" /mnt/docker/nextcloud/config/config.php

/bin/echo -e "   'dbuser' => '$MYSQL_USER_NC',\n   'dbpassword' => '$MYSQL_PASSWORD_NC',\n   'installed' => true,\n);" >> /mnt/docker/nextcloud/config/config.php

docker cp /mnt/docker/deployment/ncdb-templates/resetpw.sh nextcloud:/tmp/ && docker exec -t nextcloud bash /tmp/resetpw.sh $NEXTCLOUD_ADMIN_USER $NEXTCLOUD_ADMIN_PASSWORD
docker restart nextcloud
clear
echo "Please add the following records to your domain's DNS configuration."
find /mnt/docker/mail/dkim/ -maxdepth 1 -mindepth 1 -type d | while read line; do DOMAIN=$(basename $line); echo "  - DKIM record (TXT) for $DOMAIN:" && cat $line/public.key; done