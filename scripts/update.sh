#!/bin/bash
set -e

source /mnt/repo-base/scripts/base.sh

CURRENT_VERSION_DATE=$(git show -s --format=%ci HEAD)
git fetch --tags
LATEST_TAG=$(git tag --sort=creatordate | tail -n 1)
LATEST_VERSION_DATE=$(git show -s --format=%ci "$LATEST_TAG")

if [[ ! "$CURRENT_VERSION_DATE" < "$LATEST_VERSION_DATE" ]]
then
    echo "No update available"
    exit
fi

echo "New version is $LATEST_TAG
Changelog: https://gitlab.e.foundation/e/infra/ecloud-selfhosting/tags/$LATEST_TAG
Do you want to upgrade? [y/N]"
read  answer

# https://stackoverflow.com/a/27875395
if [ "$answer" == "${answer#[Yy]}" ] ;then
    echo "aborted"
    exit
fi

echo -e "\n\nUpdating git repository to latest version"
git checkout "$LATEST_TAG"

echo -e "\n\nUpdating Docker images"
docker-compose pull
docker-compose up -d

echo -e "\n\nUpdate complete. Consider running 'docker image prune --all' to reclaim space from old images"
