#!/bin/bash
set -e

source <(curl -s https://gitlab.e.foundation/e/infra/bootstrap/raw/master/bootstrap-commons.sh)

cd "/mnt/repo-base/"
ENVFILE="/mnt/repo-base/.env"
rm -f "$ENVFILE"

# Create .env file
generateEnvFile deployment/questionnaire/questionnaire.dat deployment/questionnaire/answers.dat "$ENVFILE"

source /mnt/repo-base/scripts/base.sh
if ! echo "$ADD_DOMAINS" | grep -q "$DOMAIN" ; then
    sed -i '/ADD_DOMAINS/d' "$ENVFILE"
    echo "ADD_DOMAINS=$ADD_DOMAINS,$DOMAIN" >> "$ENVFILE"
    source /mnt/repo-base/scripts/base.sh
fi

DC_DIR="templates/docker-compose/"
case $INSTALL_ONLYOFFICE in
    [Yy]* )
    cat "${DC_DIR}docker-compose-base.yml" "${DC_DIR}docker-compose-onlyoffice.yml" "${DC_DIR}docker-compose-networks.yml" > docker-compose.yml;
    cat "templates/nginx/sites-enabled/onlyoffice.conf" | sed "s/@@@DOMAIN@@@/$DOMAIN/g" > "config-dynamic/nginx/sites-enabled/onlyoffice.conf"
    OFFICE_DOMAIN=",office.$DOMAIN"
    OFFICE_LETSENCRYPT_KEY="config-dynamic/letsencrypt/certstore/live/office.$DOMAIN/privkey.pem"
    NUM_CERTIFICATES="4"
    ;;
    [Nn]* )
    cat "${DC_DIR}docker-compose-base.yml" "${DC_DIR}docker-compose-networks.yml" > docker-compose.yml
    NUM_CERTIFICATES="3"
    ;;
esac

# To be constructed repo specific
echo "VHOSTS_ACCOUNTS=welcome.$DOMAIN" >> "$ENVFILE"
echo "SMTP_FROM=welcome@$DOMAIN" >> "$ENVFILE"
echo "SMTP_HOST=mail.$DOMAIN" >> "$ENVFILE"

VIRTUAL_HOST=$(echo "$ADD_DOMAINS" | tr "," "\n" | while read line; do echo "autoconfig.$line,autodiscover.$line"; done | tr "\n" "," | sed 's/.$//g')

echo "VIRTUAL_HOST=$VIRTUAL_HOST" >> "$ENVFILE"

# finished .env file generation

# fille autorenew config
echo "$DOMAIN,$VIRTUAL_HOST,mail.$DOMAIN,spam.$DOMAIN,welcome.$DOMAIN$OFFICE_DOMAIN" | tr "," "\n" | while read CURDOMAIN; do
    echo "$CURDOMAIN" >> config-dynamic/letsencrypt/autorenew/ssl-domains.dat
:; done


# Configure automx
cat templates/automx/automx.conf | sed "s/@@@DOMAIN@@@/$DOMAIN/g" > "config-dynamic/automx/automx.conf"
chown www-data:www-data "config-dynamic/automx/automx.conf"

# Configure nginx vhost

# automx
echo "$DOMAIN,$ADD_DOMAINS" | tr "," "\n" | while read CURDOMAIN; do
    cat "templates/nginx/sites-enabled/autoconfig.conf" | sed "s/@@@DOMAIN@@@/$CURDOMAIN/g" | sed "s/@@@SERVICE@@@/autoconfig/g" > "config-dynamic/nginx/sites-enabled/autoconfig.$CURDOMAIN.conf"
    cat "templates/nginx/sites-enabled/autoconfig.conf" | sed "s/@@@DOMAIN@@@/$CURDOMAIN/g" | sed "s/@@@SERVICE@@@/autodiscover/g" > "config-dynamic/nginx/sites-enabled/autodiscover.$CURDOMAIN.conf"
:; done

# other hosts
cat "templates/nginx/sites-enabled/nextcloud.conf" | sed "s/@@@DOMAIN@@@/$DOMAIN/g" > "config-dynamic/nginx/sites-enabled/nextcloud.conf"
cat "templates/nginx/sites-enabled/postfixadmin.conf" | sed "s/@@@DOMAIN@@@/$DOMAIN/g" > "config-dynamic/nginx/sites-enabled/postfixadmin.conf"
cat "templates/nginx/sites-enabled/rspamd.conf" | sed "s/@@@DOMAIN@@@/$DOMAIN/g" > "config-dynamic/nginx/sites-enabled/rspamd.conf"
cat "templates/nginx/sites-enabled/welcome.conf" | sed "s/@@@DOMAIN@@@/$DOMAIN/g" > "config-dynamic/nginx/sites-enabled/welcome.conf"

# confirm DNS is ready
echo ""
echo ""
echo "================================================================================================================================="
echo "================================================================================================================================="
echo "Please setup the following DNS records for your domains before you proceed (subsequent steps will fail if a record is missing):"
echo ""
echo "   mail.$DOMAIN A record to your public IP"
echo "   For each domain in $ADD_DOMAINS add an A record (@) to your public IP"
echo "   For each domain in $ADD_DOMAINS add an MX record (@, priority 10) towards mail.$DOMAIN.com."
echo "   PTR record for your public IP towards mail.$DOMAIN.com (reverse DNS to match A record above)"
echo ""
echo "$VIRTUAL_HOST,spam.$DOMAIN,welcome.$DOMAIN$OFFICE_DOMAIN" | tr "," "\n" | while read CURDOMAIN; do
    echo "   CNAME record $CURDOMAIN towards mail.$DOMAIN."
:; done
echo "================================================================================================================================="
echo "================================================================================================================================="
echo ""

echo "Type 'yes' and hit ENTER to confirm that you have setup DNS properly before we continue:"
read CONFIRM
while [ "$CONFIRM" != "yes" ]
do
    read CONFIRM
done

# Verify DOMAIN lookup forward and reverse (very important)
IP=$(dig mail.$DOMAIN| grep mail.$DOMAIN | grep -v '^;' | awk '{ print $NF }')

if [ -z "$IP" ]
then
    echo "mail.$DOMAIN not resolving to IP"
    exit 1
fi
PTR=$(nslookup $IP | grep "name = mail.$DOMAIN" | wc -l)

if [ "1" != "$PTR" ]
then
    echo "$IP not resolving to mail.$DOMAIN (PTR record missing or wrong.."
    exit 1
fi

# Run LE cert request
bash scripts/ssl-renew.sh

# verify LE status
CTR_LE=$(find config-dynamic/letsencrypt/certstore/live/mail.$DOMAIN/privkey.pem config-dynamic/letsencrypt/certstore/live/spam.$DOMAIN/privkey.pem config-dynamic/letsencrypt/certstore/live/welcome.$DOMAIN/privkey.pem $OFFICE_LETSENCRYPT_KEY 2>/dev/null| wc -l)
CTR_AC_LE=$(echo "$VIRTUAL_HOST" | tr "," "\n" | while read CURDOMAIN; do find config-dynamic/letsencrypt/certstore/live/$CURDOMAIN/privkey.pem 2>/dev/null | grep $CURDOMAIN && echo found || echo missing; done  | grep missing | wc  -l)

if [ "$CTR_LE$CTR_AC_LE" = "${NUM_CERTIFICATES}0" ]
then
    echo "All LE certs present."
else
    echo "Verification of LE status failed. Some expected certificates are missing"
    echo "$CTR_LE of $NUM_CERTIFICATES certifcates found."
    echo "$CTR_AC_LE autoconfig/autodiscovery certificates are missing."
    exit 1
fi

# create nextcloud config
mkdir -p "/mnt/repo-base/volumes/nextcloud/config/"
cat /mnt/repo-base/templates/nextcloud/config.php | sed "s/@@@DOMAIN@@@/$DOMAIN/g" | \
    sed "s/@@@DRIVE_SMTP_PASSWORD@@@/$DRIVE_SMTP_PASSWORD/g" | sed "s/@@@MYSQL_PASSWORD_NC@@@/$MYSQL_PASSWORD_NC/g" | \
    sed "s/@@@MYSQL_DATABASE_NC@@@/$MYSQL_DATABASE_NC/g" | sed "s/@@MYSQL_USER_NC@@@/$MYSQL_USER_NC/g" > \
    "/mnt/repo-base/volumes/nextcloud/config/config.php"
chown www-data:www-data "/mnt/repo-base/volumes/nextcloud/" -R

# Login to /e/ registry | not necessary when going public
echo "Please login with your gitlab.e.foundation username and password"
docker login registry.gitlab.e.foundation:5000

docker-compose up -d

echo -e "\nHack: restart everything to ensure that database and nextcloud are initialized"
docker-compose restart

# needed to store created accounts, and needs to be writable by welcome
touch /mnt/repo-base/volumes/accounts/auth.file.done
ACCOUNTS_UID=$(docker-compose exec --user www-data accounts id -u | tr -d '\r')
chown "$ACCOUNTS_UID:$ACCOUNTS_UID" /mnt/repo-base/volumes/accounts/auth.file.done

bash scripts/postinstall.sh
