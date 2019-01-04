#!/usr/bin/env bash
ENVFILE="/mnt/docker/.env"

SPAMUI=$(grep server_name $(grep -l mailserver:11334 /mnt/docker/nginx/sites-enabled/*.conf) | sort -u | head -n1 | awk '{ print $2 }' | sed 's/;$//g')
RSPAMD_PASSWORD=$(grep ^RSPAMD_PASSWORD= "$ENVFILE"  | awk -F= '{ print $NF }')

NCUI=$(grep server_name $(grep -l nextcloud:80 /mnt/docker/nginx/sites-enabled/*.conf) | sort -u | head -n1 | awk '{ print $2 }' | sed 's/;$//g')
NEXTCLOUD_ADMIN_USER=$(grep ^NEXTCLOUD_ADMIN_USER= "$ENVFILE" | awk -F= '{ print $NF }')
NEXTCLOUD_ADMIN_PASSWORD=$(grep ^NEXTCLOUD_ADMIN_PASSWORD= "$ENVFILE" | awk -F= '{ print $NF }')

DBAUI=$(grep server_name $(grep -l pma:80 /mnt/docker/nginx/sites-enabled/*.conf) | sort -u | head -n1 | awk '{ print $2 }' | sed 's/;$//g')
DBA_USER=$(grep ^DBA_USER= "$ENVFILE"  | awk -F= '{ print $NF }')
DBA_PASSWORD=$(grep ^DBA_PASSWORD= "$ENVFILE"  | awk -F= '{ print $NF }')

echo "Your password for the SPAM filter mgmt UI (https://$SPAMUI) is: $RSPAMD_PASSWORD"
echo "Your admin credentials for nextcloud are (https://$NCUI) is: $NEXTCLOUD_ADMIN_USER / $NEXTCLOUD_ADMIN_PASSWORD"
echo "Your credentials for phpmyadmin (https://$DBAUI) are: $DBA_USER / $DBA_PASSWORD"