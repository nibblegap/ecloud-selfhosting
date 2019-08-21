#!/bin/bash
#set -e

source /mnt/repo-base/scripts/base.sh

CONFIG=/mnt/repo-base/config-dynamic/letsencrypt/autorenew/ssl-domains.dat
CONFIG_DIR=/mnt/repo-base/config-dynamic/letsencrypt/certstore
LIVE_DIR=$CONFIG_DIR/live

cat "$CONFIG" | while read DOMAIN; do
    echo "Checking $DOMAIN"
    # For the first run, we have to use standalone auth because Nginx won't start without the cert files present.
    if [ ! -L "$LIVE_DIR/$DOMAIN/fullchain.pem" ]; then
        certbot certonly -d "$DOMAIN" -m "$ALT_EMAIL" --standalone --agree-tos --non-interactive \
            --config-dir="$CONFIG_DIR"
    else
        CERT_UPDATED_FILE="$LIVE_DIR/$DOMAIN/cert-updated"
        certbot certonly -d "$DOMAIN" --non-interactive --webroot \
            --webroot-path='/mnt/repo-base/config-dynamic/letsencrypt/acme-challenge/' \
            --config-dir="$CONFIG_DIR" \
            --deploy-hook "touch $CERT_UPDATED_FILE"
        # add the following parameters to test renewal (will install invalid certificates)
        # --test-cert --force-renewal --break-my-certs
        if [ -f "$CERT_UPDATED_FILE" ]; then
            rm "$CERT_UPDATED_FILE"
            VALID_UNTIL=$(openssl x509 -enddate -noout -in $LIVE_DIR/$DOMAIN/fullchain.pem | awk -F= '{ print $NF }')
            echo "Certificate for $DOMAIN renewed and is valid until: $VALID_UNTIL"
            docker-compose exec -T nginx nginx -s reload
            if [ "$DOMAIN" = "$MAILHOST" ]; then
                docker-compose restart eelomailserver
            fi
        fi
    fi
:;done
