#!/bin/bash
set -e

source /mnt/repo-base/scripts/base.sh

KNOWN_VERSION_FILE="/mnt/repo-base/config/latest-known-version"
# TODO: delete this once config folder is included in the repo
mkdir /mnt/repo-base/config/ || true
touch $KNOWN_VERSION_FILE

CURRENT_VERSION_DATE=$(git show -s --format=%ci HEAD)
git fetch --tags
LATEST_TAG=$(git tag --sort=creatordate | tail -n 1)
LATEST_VERSION_DATE=$(git show -s --format=%ci "$LATEST_TAG")

if [[ "$LATEST_VERSION_DATE" > "$CURRENT_VERSION_DATE" ]]
then
    echo "New version $LATEST_TAG is available!"
    if [ "$LATEST_TAG" != "$(cat $KNOWN_VERSION_FILE)" ]
    then
        echo "$LATEST_TAG" > "$KNOWN_VERSION_FILE"
        cat "templates/mail/update-notification.txt" | \
            sed "s/@@@DOMAIN@@@/$DOMAIN/g" | \
            docker-compose exec -T eelomailserver sendmail -f "drive@$DOMAIN" -t "$ALT_EMAIL"
    fi
else
    echo "No update available"
fi
