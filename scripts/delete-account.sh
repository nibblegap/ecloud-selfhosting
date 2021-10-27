#!/bin/bash
set -e

source /mnt/repo-base/scripts/base.sh

ACCOUNT=$1

if ! docker-compose exec -T -u www-data nextcloud php occ user:info "$ACCOUNT" | grep "$ACCOUNT" --quiet; then
    echo "Error: The account $ACCOUNT does not exist"
    exit
fi

echo "Please confirm to delete the user account $ACCOUNT including all data. This is not reversible."
read -r -p "[y/N] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "Deleting Nextcloud account"
    docker-compose exec -T -u www-data nextcloud php occ user:delete "$ACCOUNT"

    echo "Deleting email account"
    docker-compose exec -T postfixadmin /postfixadmin/scripts/postfixadmin-cli mailbox delete "$ACCOUNT"

fi
