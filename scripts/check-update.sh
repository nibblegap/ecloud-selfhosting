#!/bin/bash
set -e

source /mnt/repo-base/scripts/base.sh

# This file stores the latest tag that we have seen in the repo. It is used
# to ensure that we dont send out multiple emails for the same update.
KNOWN_VERSION_FILE="/mnt/repo-base/config-dynamic/updater/latest-known-version"

# Create file and populate with current version on first run.
if [ ! -f $KNOWN_VERSION_FILE ]; then
    mkdir -p "/mnt/repo-base/config-dynamic/updater/"
    git tag --sort=creatordate | tail -n 1 > $KNOWN_VERSION_FILE
fi

git fetch --tags
LATEST_TAG=$(git tag --sort=creatordate | tail -n 1)

echo "Current version: $(git describe), latest tag: $LATEST_TAG"
if [ "$LATEST_TAG" != "$(cat $KNOWN_VERSION_FILE)" ]; then
    echo "New version $LATEST_TAG is available!"
    echo $LATEST_TAG > $KNOWN_VERSION_FILE
    cat "templates/mail/update-notification.txt" | \
        sed "s/@@@VERSION@@@/$LATEST_TAG/g" | \
        docker-compose exec -T eelomailserver sendmail -f "drive@$DOMAIN" -t "$ALT_EMAIL"
fi
