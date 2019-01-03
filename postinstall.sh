#!/usr/bin/env bash
ENVFILE="/mnt/docker/.env"
NEXTCLOUD_ADMIN_USER=$(grep ^NEXTCLOUD_ADMIN_USER= "$ENVFILE" | awk -F= '{ print $NF }')
NEXTCLOUD_ADMIN_PASSWORD=$(grep ^NEXTCLOUD_ADMIN_PASSWORD= "$ENVFILE" | awk -F= '{ print $NF }')
docker cp /mnt/docker/deployment/ncdb-templates/resetpw.sh nextcloud:/tmp/ && docker exec -t nextcloud bash /tmp/resetpw.sh $NEXTCLOUD_ADMIN_USER $NEXTCLOUD_ADMIN_PASSWORD
clear
echo "Please add the following records to your domain's DNS configuration."
find /mnt/docker/mail/dkim/ -maxdepth 1 -mindepth 1 -type d | while read line; do DOMAIN=$(basename $line); echo "  - DKIM record (TXT) for $DOMAIN:" && cat $line/public.key; done