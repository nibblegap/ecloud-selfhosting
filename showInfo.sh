#!/usr/bin/env bash

SPAMUI=$(grep server_name $(grep -l mailserver:11334 /mnt/docker/nginx/sites-enabled/*.conf) | sort -u | head -n1 | awk '{ print $2 }' | sed 's/;$//g')
RSPAMD_PASSWORD=$(grep RSPAMD_PASSWORD /mnt/docker/.env  | awk -F= '{ print $NF }')

NCUI=$(grep server_name $(grep -l nextcloud:80 /mnt/docker/nginx/sites-enabled/*.conf) | sort -u | head -n1 | awk '{ print $2 }' | sed 's/;$//g')
NC_ADMINPW=$(grep NEXTCLOUD_ADMIN_PASSWORD /mnt/docker/.env  | awk -F= '{ print $NF }')


DBAUI=$(grep server_name $(grep -l pma:80 /mnt/docker/nginx/sites-enabled/*.conf) | sort -u | head -n1 | awk '{ print $2 }' | sed 's/;$//g')
DBA_USER=$(grep DBA_USER /mnt/docker/.env  | awk -F= '{ print $NF }')
DBA_PASSWORD=$(grep DBA_PASSWORD /mnt/docker/.env  | awk -F= '{ print $NF }')

echo "Your password for the SPAM filter mgmt UI (https://$SPAMUI) is: $RSPAMD_PASSWORD"
echo "Your admin password for nextcloud is (https://$NCUI) is: $NC_ADMINPW"
echo "Your credentials for phpmyadmin (https://$DBAUI) are: $DBA_USER / $DBA_PASSWORD"