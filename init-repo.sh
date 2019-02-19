#!/bin/bash
set -e

#source <(curl -s https://gitlab.e.foundation/thilo/bootstrap/raw/master/bootstrap-commons.sh)
source <(curl -s https://gitlab.e.foundation/e/infra/bootstrap/raw/master/bootstrap-commons.sh)

ENVFILE="/mnt/docker/.env"
rm -f "$ENVFILE"

# Create .env file
generateEnvFile deployment/questionnaire/questionnaire.dat deployment/questionnaire/answers.dat "$ENVFILE"

DOMAIN=$(grep ^DOMAIN= "$ENVFILE" | awk -F= '{ print $NF }')
ADD_DOMAINS=$(grep ^ADD_DOMAINS= "$ENVFILE" | awk -F= '{ print $NF }')

DBA_USER=$(grep ^DBA_USER= "$ENVFILE" | awk -F= '{ print $NF }')
DBA_PASSWORD=$(grep ^DBA_PASSWORD= "$ENVFILE" | awk -F= '{ print $NF }')

NEXTCLOUD_ADMIN_USER=$(grep ^NEXTCLOUD_ADMIN_USER= "$ENVFILE" | awk -F= '{ print $NF }')

MYSQL_DATABASE_NC=$(grep ^MYSQL_DATABASE_NC= "$ENVFILE" | awk -F= '{ print $NF }')
MYSQL_USER_NC=$(grep ^MYSQL_USER_NC= "$ENVFILE" | awk -F= '{ print $NF }')
MYSQL_PASSWORD_NC=$(grep ^MYSQL_PASSWORD_NC= "$ENVFILE" | awk -F= '{ print $NF }')

INSTALL_ONLYOFFICE=$(grep ^INSTALL_ONLYOFFICE= "$ENVFILE" | awk -F= '{ print $NF }')

case $INSTALL_ONLYOFFICE in
    [Yy]* )
    cat docker-compose-base.yml docker-compose-onlyoffice.yml docker-compose-networks.yml > docker-compose.yml;
    cat nginx/templates/office | sed "s/@@@DOMAIN@@@/$DOMAIN/g" > "nginx/sites-enabled/office.$DOMAIN.conf"
    OFFICE_DOMAIN=",office.$DOMAIN"
    OFFICE_LETSENCRYPT_KEY="letsencrypt/certstore/live/office.$DOMAIN/privkey.pem"
    NUM_CERTIFICATES="7"
    ;;
    [Nn]* )
    cat docker-compose-base.yml docker-compose-networks.yml > docker-compose.yml
    NUM_CERTIFICATES="6"
    ;;
esac

# Create folder structure
cd /mnt/docker && grep mnt docker-compose.yml  | grep -v \# | awk '{ print $2 }' | awk -F: '{ print $1 }' | sed 's@m/.*conf$@m@g'  | grep -v -e id_rsa -v -e exclude_names| sed 's@x/.*conf$@x@g' | sort -u | while read line; do mkdir -p "$line"; done

# prepare nextcloud DB init scripts
cat /mnt/docker/deployment/ncdb-templates/a_user.sql | sed "s/@@@USER@@@/$MYSQL_USER_NC/g" | sed "s/@@@PASSWORD@@@/$MYSQL_PASSWORD_NC/g" > /mnt/docker/deployment/ncdb/a_user.sql
cat /mnt/docker/deployment/ncdb-templates/b_db.sql | sed "s/@@@ADMINUSER@@@/$NEXTCLOUD_ADMIN_USER/g" | sed "s/@@@DBNAME@@@/$MYSQL_DATABASE_NC/g" > /mnt/docker/deployment/ncdb/b_db.sql
cat /mnt/docker/deployment/ncdb-templates/c_grant.sql | sed "s/@@@USER@@@/$MYSQL_USER_NC/g" | sed "s/@@@DBNAME@@@/$MYSQL_DATABASE_NC/g" > /mnt/docker/deployment/ncdb/c_grant.sql

# To be constructed repo specific
echo "VHOSTS_ACCOUNTS=welcome.$DOMAIN" >> "$ENVFILE"
echo "SMTP_FROM=welcome@$DOMAIN" >> "$ENVFILE"

# generate basic auth for phpmyadmin
htpasswd -c  -b /mnt/docker/nginx/passwds/pma.htpasswd $DBA_USER "$DBA_PASSWORD"

VIRTUAL_HOST=$(echo "$ADD_DOMAINS" | tr "," "\n" | while read line; do echo "autoconfig.$line,autodiscover.$line"; done | tr "\n" "," | sed 's/.$//g')

echo "VIRTUAL_HOST=$VIRTUAL_HOST" >> "$ENVFILE"

# finished .env file generation

mkdir letsencrypt/autorenew/
rm -f letsencrypt/autorenew/ssl-domains.dat
# fille autorenew config
echo "$VIRTUAL_HOST,dba.$DOMAIN,drive.$DOMAIN,mail.$DOMAIN,spam.$DOMAIN,webmail.$DOMAIN,welcome.$DOMAIN$OFFICE_DOMAIN" | tr "," "\n" | while read CURDOMAIN; do
    echo "sub        $CURDOMAIN" >> letsencrypt/autorenew/ssl-domains.dat
:; done


# Configure automx
cat automx/automx-template.conf | sed "s/@@@DOMAIN@@@/$DOMAIN/g" > automx/automx.conf

# Configure nginx vhost

# automx
echo "$DOMAIN,$ADD_DOMAINS" | tr "," "\n" | while read CURDOMAIN; do
    cat nginx/templates/autoconfig | sed "s/@@@DOMAIN@@@/$CURDOMAIN/g" | sed "s/@@@SERVICE@@@/autoconfig/g" > nginx/sites-enabled/autoconfig.$CURDOMAIN.conf
    cat nginx/templates/autoconfig | sed "s/@@@DOMAIN@@@/$CURDOMAIN/g" | sed "s/@@@SERVICE@@@/autodiscover/g" > nginx/sites-enabled/autodiscover.$CURDOMAIN.conf
:; done

# other hosts
cat nginx/templates/dba | sed "s/@@@DOMAIN@@@/$DOMAIN/g" > "nginx/sites-enabled/dba.$DOMAIN.conf"
cat nginx/templates/drive | sed "s/@@@DOMAIN@@@/$DOMAIN/g" > "nginx/sites-enabled/drive.$DOMAIN.conf"
cat nginx/templates/mail | sed "s/@@@DOMAIN@@@/$DOMAIN/g" > "nginx/sites-enabled/mail.$DOMAIN.conf"
cat nginx/templates/spam | sed "s/@@@DOMAIN@@@/$DOMAIN/g" > "nginx/sites-enabled/spam.$DOMAIN.conf"
cat nginx/templates/webmail | sed "s/@@@DOMAIN@@@/$DOMAIN/g" > "nginx/sites-enabled/webmail.$DOMAIN.conf"
cat nginx/templates/welcome | sed "s/@@@DOMAIN@@@/$DOMAIN/g" > "nginx/sites-enabled/welcome.$DOMAIN.conf"

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
echo "$VIRTUAL_HOST,dba.$DOMAIN,drive.$DOMAIN,spam.$DOMAIN,webmail.$DOMAIN,welcome.$DOMAIN$OFFICE_DOMAIN" | tr "," "\n" | while read CURDOMAIN; do
    echo "   CNAME record $CURDOMAIN towards mail.$DOMAIN."
:; done
echo "================================================================================================================================="
echo "================================================================================================================================="
echo ""
echo "Type 'yes' and hit ENTER to confirm that you have setup DNS properly before we continue (everything else will abort the process):"
read CONFIRM < /dev/tty

if [ "yes" != "$CONFIRM" ]
then
    echo "Aborting"
    exit 1
fi

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

# Need to get the numeric UIDs for chown. Unfortunately these commands fail because
# the containers are not created yet. But the chown has to be performed before the
# container is first started, or the ssh key copying in postfixadmin will fail.
#ACCOUNTS_UID=$(docker-compose exec --user www-data accounts id -u | tr -d '\r')
#PFEXEC_UID=$(docker-compose exec --user pfexec postfixadmin id -u | tr -d '\r')

# Generate ssh key for welcome
ssh-keygen -f /mnt/docker/accounts/id_rsa_postfixadmincontainer -N ""
chown "33:33" /mnt/docker/accounts/id_rsa_postfixadmincontainer
chown "1000:1000" /mnt/docker/accounts/id_rsa_postfixadmincontainer.pub

# needed to store created accounts, and needs to be writable by welcome
touch /mnt/docker/accounts/auth.file.done
chown "33:33" /mnt/docker/accounts/auth.file.done

# Run LE cert request
bash scripts/ssl-renew.sh

# verify LE status
CTR_LE=$(find letsencrypt/certstore/live/dba.$DOMAIN/privkey.pem letsencrypt/certstore/live/drive.$DOMAIN/privkey.pem letsencrypt/certstore/live/mail.$DOMAIN/privkey.pem letsencrypt/certstore/live/spam.$DOMAIN/privkey.pem letsencrypt/certstore/live/webmail.$DOMAIN/privkey.pem letsencrypt/certstore/live/welcome.$DOMAIN/privkey.pem $OFFICE_LETSENCRYPT_KEY 2>/dev/null| wc -l)
CTR_AC_LE=$(echo "$VIRTUAL_HOST" | tr "," "\n" | while read CURDOMAIN; do find letsencrypt/certstore/live/$CURDOMAIN/privkey.pem 2>/dev/null | grep $CURDOMAIN && echo found || echo missing; done  | grep missing | wc  -l)

if [ "$CTR_LE$CTR_AC_LE" = "${NUM_CERTIFICATES}0" ]
then
    echo "All LE certs present."
else
    echo "Verification of LE status failed. Some expected certificates are missing"
    echo "$CTR_LE of $NUM_CERTIFICATES certifcates found."
    echo "$CTR_AC_LE autoconfig/autodiscovery certificates are missing."
    exit 1
fi

# Login to /e/ registry | not necessary when going public
echo "Please login with your gitlab.e.foundation username and password"
docker login registry.gitlab.e.foundation:5000

cd /mnt/docker/
docker-compose up -d

bash /mnt/repo-base/postinstall.sh
