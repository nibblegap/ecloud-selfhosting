#!/bin/bash
set -e

source /mnt/repo-base/scripts/base.sh

ACCOUNT=$1

docker-compose exec -T -u www-data nextcloud php occ user:delete "$ACCOUNT"

docker-compose exec -T postfixadmin /postfixadmin/scripts/postfixadmin-cli mailbox delete "$ACCOUNT"

# TODO: delete onlyoffice account???
