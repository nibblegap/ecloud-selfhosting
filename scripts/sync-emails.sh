#!/bin/bash
set -e

source /mnt/repo-base/scripts/base.sh

QUERY_RESULT=$(docker-compose exec -T mariadb mysql --user=root --password="$MYSQL_ROOT_PASSWORD" --database=$MYSQL_DATABASE_NC -N -B \
    -e "SELECT uid,json_unquote(json_extract(data,'$.email.value')) AS email FROM accounts;")

UPDATE_QUERY="UPDATE mailbox SET email_other = CASE username "
while read -r line; do
    USER=$(echo "$line" | cut -f1)
    FALLBACK_EMAIL=$(echo "$line" | cut -f2)
    if [ "$FALLBACK_EMAIL" = "null" ]; then
        continue
    fi
    UPDATE_QUERY+="WHEN '$USER' THEN '$FALLBACK_EMAIL' "
done <<< "$QUERY_RESULT"
UPDATE_QUERY+="ELSE email_other END;"

docker-compose exec -T mariadb mysql --user=root --password="$MYSQL_ROOT_PASSWORD" --database=postfix \
    -e "$UPDATE_QUERY"
