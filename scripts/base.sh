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
NEXTCLOUD_ADMIN_PASSWORD=$(grep ^NEXTCLOUD_ADMIN_PASSWORD= "$ENVFILE" | awk -F= '{ print $NF }')

MYSQL_DATABASE_NC=$(grep ^MYSQL_DATABASE_NC= "$ENVFILE" | awk -F= '{ print $NF }')
MYSQL_USER_NC=$(grep ^MYSQL_USER_NC= "$ENVFILE" | awk -F= '{ print $NF }')
MYSQL_PASSWORD_NC=$(grep ^MYSQL_PASSWORD_NC= "$ENVFILE" | awk -F= '{ print $NF }')
MYSQL_ROOT_PASSWORD=$(grep ^MYSQL_ROOT_PASSWORD= "$ENVFILE" | awk -F= '{ print $NF }')

INSTALL_ONLYOFFICE=$(grep ^INSTALL_ONLYOFFICE= "$ENVFILE" | awk -F= '{ print $NF }')

DRIVE_SMTP_PASSWORD=$(grep ^DRIVE_SMTP_PASSWORD= "$ENVFILE" | awk -F= '{ print $NF }')

PFA_SUPERADMIN_PASSWORD=$(grep ^PFA_SUPERADMIN_PASSWORD= "$ENVFILE" | awk -F= '{ print $NF }')

PFDB_DB=$(grep ^PFDB_DB= "$ENVFILE" | awk -F= '{ print $NF }')
PFDB_USR=$(grep ^PFDB_USR= "$ENVFILE" | awk -F= '{ print $NF }')
PFDB_DBPASS=$(grep ^DBPASS= "$ENVFILE" | awk -F= '{ print $NF }')

SMTP_FROM=$(grep ^SMTP_FROM= "$ENVFILE" | awk -F= '{ print $NF }')
SMTP_PW=$(grep ^SMTP_PW= "$ENVFILE" | awk -F= '{ print $NF }')

SMTP_HOST=$(grep ^SMTP_HOST= "$ENVFILE" | awk -F= '{ print $NF }')


# the encoding/decoding is taken from here: https://stackoverflow.com/questions/296536/how-to-urlencode-data-for-curl-command/10660730#10660730
urlencode() {
  local string="${1}"
  local strlen=${#string}
  local encoded=""
  local pos c o

  for (( pos=0 ; pos<strlen ; pos++ )); do
     c=${string:$pos:1}
     case "$c" in
        [-_.~a-zA-Z0-9] ) o="${c}" ;;
        * )               printf -v o '%%%02x' "'$c"
     esac
     encoded+="${o}"
  done
  echo "${encoded}"    # You can either set a return variable (FASTER)
}

urldecode() {
  # This is perhaps a risky gambit, but since all escape characters must be
  # encoded, we can replace %NN with \xNN and pass the lot to printf -b, which
  # will decode hex for us

  printf -v REPLY '%b' "${1//%/\\x}" # You can either set a return variable (FASTER)

  echo "${REPLY}"  #+or echo the result (EASIER)... or both... :p
}
