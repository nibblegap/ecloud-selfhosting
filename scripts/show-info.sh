#!/usr/bin/env bash
set -e

source /mnt/repo-base/scripts/base.sh

SPAM_UI=$(grep server_name $(grep -l mailserver:11334 /mnt/repo-base/config/nginx/sites-enabled/*.conf) | sort -u | head -n1 | awk '{ print $2 }' | sed 's/;$//g')
RSPAMD_PASSWORD=$(grep ^RSPAMD_PASSWORD= "$ENVFILE"  | awk -F= '{ print $NF }')

NEXTCLOUD_UI=$(grep server_name $(grep -l nextcloud:9000 /mnt/repo-base/config/nginx/sites-enabled/*.conf) | sort -u | head -n1 | awk '{ print $2 }' | sed 's/;$//g')
NEXTCLOUD_ADMIN_USER=$(grep ^NEXTCLOUD_ADMIN_USER= "$ENVFILE" | awk -F= '{ print $NF }')
NEXTCLOUD_ADMIN_PASSWORD=$(grep ^NEXTCLOUD_ADMIN_PASSWORD= "$ENVFILE" | awk -F= '{ print $NF }')

POSTFIX_UI=$(grep server_name $(grep -l postfixadmin /mnt/repo-base/config/nginx/sites-enabled/*.conf) | sort -u | head -n1 | awk '{ print $2 }' | sed 's/;$//g')
POSTFIX_USER=$(grep ALT_EMAIL= "$ENVFILE"  | awk -F= '{ print $NF }')
POSTFIX_PASSWORD=$(grep PFA_SUPERADMIN_PASSWORD= "$ENVFILE"  | awk -F= '{ print $NF }')


echo "Your password for the SPAM filter mgmt UI (https://$SPAM_UI) is: $RSPAMD_PASSWORD"
echo "Your admin credentials for nextcloud are (https://$NEXTCLOUD_UI) is: $NEXTCLOUD_ADMIN_USER / $NEXTCLOUD_ADMIN_PASSWORD"
echo "Your credentials for postfix admin (https://$POSTFIX_UI) are: $POSTFIX_USER / $POSTFIX_PASSWORD"

