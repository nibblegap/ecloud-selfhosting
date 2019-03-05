#!/bin/bash
# No set -e, because that would close the ssh connection if we source base.sh
# into an interactive shell.

cd "/mnt/repo-base/"

ENVFILE="/mnt/repo-base/.env"

DOMAIN=$(grep ^DOMAIN= "$ENVFILE" | awk -F= '{ print $NF }')
ADD_DOMAINS=$(grep ^ADD_DOMAINS= "$ENVFILE" | awk -F= '{ print $NF }')
ALT_EMAIL=$(grep ^ALT_EMAIL= "$ENVFILE" | awk -F= '{ print $NF }')

DBA_USER=$(grep ^DBA_USER= "$ENVFILE" | awk -F= '{ print $NF }')
DBA_PASSWORD=$(grep ^DBA_PASSWORD= "$ENVFILE" | awk -F= '{ print $NF }')

NEXTCLOUD_ADMIN_USER=$(grep ^NEXTCLOUD_ADMIN_USER= "$ENVFILE" | awk -F= '{ print $NF }')

MYSQL_DATABASE_NC=$(grep ^MYSQL_DATABASE_NC= "$ENVFILE" | awk -F= '{ print $NF }')
MYSQL_USER_NC=$(grep ^MYSQL_USER_NC= "$ENVFILE" | awk -F= '{ print $NF }')
MYSQL_PASSWORD_NC=$(grep ^MYSQL_PASSWORD_NC= "$ENVFILE" | awk -F= '{ print $NF }')

INSTALL_ONLYOFFICE=$(grep ^INSTALL_ONLYOFFICE= "$ENVFILE" | awk -F= '{ print $NF }')

DRIVE_SMTP_PASSWORD=$(grep ^DRIVE_SMTP_PASSWORD= "$ENVFILE" | awk -F= '{ print $NF }')

PFA_SUPERADMIN_PASSWORD=$(grep ^PFA_SUPERADMIN_PASSWORD= "$ENVFILE" | awk -F= '{ print $NF }')

PFDB_DB=$(grep ^PFDB_DB= "$ENVFILE" | awk -F= '{ print $NF }')
PFDB_USR=$(grep ^PFDB_USR= "$ENVFILE" | awk -F= '{ print $NF }')
PFDB_DBPASS=$(grep ^DBPASS= "$ENVFILE" | awk -F= '{ print $NF }')
