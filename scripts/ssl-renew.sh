#!/bin/bash
#set -e

source /mnt/repo-base/scripts/base.sh

CONFIG_DIR_ROOT=/mnt/repo-base/config/letsencrypt
CERTS_DIR=$CONFIG_DIR_ROOT/certstore
CHALLENGE_DIR=$CONFIG_DIR_ROOT/acme-challenge
LIVE_DIR=$CERTS_DIR/live
CONFIG=$CONFIG_DIR_ROOT/autorenew/ssl-domains.dat

NEED_NGINX_RESTART=false

while read -ra DOMAIN_ARGS
do
    DOMAIN="${DOMAIN_ARGS[0]}"
    echo "Checking $DOMAIN"
    i=0
    for domain in "${DOMAIN_ARGS[@]}"; do DOMAIN_ARGS[$i]="-d $domain"; ((++i)); done
    # For the first run, we have to use standalone auth because Nginx won't start without the cert files present.
    if [ ! -L "$LIVE_DIR/$DOMAIN/fullchain.pem" ]; then
        certbot certonly "${DOMAIN_ARGS[@]}" -m "$ALT_EMAIL" --agree-tos --non-interactive --standalone  \
            --config-dir="$CERTS_DIR"
    else
        CERT_UPDATED_FILE="$LIVE_DIR/$DOMAIN/cert-updated"
        certbot certonly "${DOMAIN_ARGS[@]}" -m "$ALT_EMAIL" --agree-tos --non-interactive --expand \
            --config-dir="$CERTS_DIR" \
            --deploy-hook "touch $CERT_UPDATED_FILE" \
            --webroot --webroot-path="$CHALLENGE_DIR"
        # add the following parameters to test renewal (will install invalid certificates)
        # --test-cert --force-renewal --break-my-certs
        if [ -f "$CERT_UPDATED_FILE" ]; then
            NEED_NGINX_RESTART="true"
            rm "$CERT_UPDATED_FILE"
            VALID_UNTIL=$(openssl x509 -enddate -noout -in $LIVE_DIR/$DOMAIN/fullchain.pem | awk -F= '{ print $NF }')
            echo "Certificate for $DOMAIN renewed and is valid until: $VALID_UNTIL"
            if [ "$DOMAIN" = "$MAILHOST" ]; then
                docker-compose restart mailserver
            fi
        fi
    fi
done <<< "$(cat $CONFIG)"

if [ "$NEED_NGINX_RESTART" = true ]; then
    docker-compose exec -T nginx nginx -s reload
    echo "Nginx restarted, as at least one certificate has been renewed."
else
    echo "No certificate renewed, no need to restart Nginx."
fi
