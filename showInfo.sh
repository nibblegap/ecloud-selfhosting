#!/usr/bin/env bash

SPAMUI=$(grep server_name $(grep -l mailserver:11334 /mnt/docker/nginx/sites-enabled/*.conf) | sort -u | head -n1 | awk '{ print $2 }' | sed 's/;$//g')
RSPAMD_PASSWORD=$(grep RSPAMD_PASSWORD /mnt/docker/.env  | awk -F= '{ print $NF }')

NCUI=$(grep server_name $(grep -l nextcloud:80 /mnt/docker/nginx/sites-enabled/*.conf) | sort -u | head -n1 | awk '{ print $2 }' | sed 's/;$//g')
NC_ADMINPW=$(grep NEXTCLOUD_ADMIN_PASSWORD /mnt/docker/.env  | awk -F= '{ print $NF }')

echo "Your password for the SPAM filter mgmt UI (https://$SPAMUI) is: $RSPAMD_PASSWORD"