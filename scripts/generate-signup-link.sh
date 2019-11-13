#!/bin/bash
set -e

source /mnt/repo-base/scripts/base.sh

if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
  echo "Usage: `basename $0` -- Creates a new signup link
  options:
  --user-email  Pass the email address for the new user, so there is no need to prompt for it
  --help        Show this help"
  exit 0
fi

if [[ "$1" == "--user-email" ]]; then
    EMAIL="$2"
else
    echo "What is the new user's current email address?"
    read EMAIL
fi


AUTH_SECRET=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)
echo "$EMAIL:$AUTH_SECRET" >> /mnt/repo-base/volumes/accounts/auth.file
ENCODED_EMAIL=$(jq -nr --arg v "$EMAIL" '$v|@uri')
SIGNUP_URL="https://welcome.$DOMAIN/?authmail=$ENCODED_EMAIL&authsecret=$AUTH_SECRET"
echo "The new user can sign up now at $SIGNUP_URL"

echo -e "to:$EMAIL
from:drive@$DOMAIN
subject:Signup for $DOMAIN
You can now sign up for your $DOMAIN account at $SIGNUP_URL" | \
    docker exec -i $(docker-compose ps -q eelomailserver) sendmail -t
