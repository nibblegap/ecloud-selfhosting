#!/bin/bash

#source <(curl -s https://gitlab.e.foundation/thilo/bootstrap/raw/master/bootstrap-commons.sh)
source <(curl -s https://gitlab.e.foundation/e/infra/bootstrap/raw/master/bootstrap-commons.sh)

# Create folder structure
cd /mnt/docker && grep mnt docker-compose-autogen.yml  | grep -v \# | awk '{ print $2 }' | awk -F: '{ print $1 }' | sed 's@m/.*conf$@m@g' | grep -v id_rsa | while read line; do dirname $line; done | sort -u | while read line; do mkdir -p "$line"; done

ENVFILE="/mnt/docker/.env"
rm -f "$ENVFILE"

# Create .env file
generateEnvFile deployment/questionnaire/questionnaire.dat deployment/questionnaire/answers.dat "$ENVFILE"

DOMAIN=$(grep ^DOMAIN= "$ENVFILE" | awk -F= '{ print $NF }')
ADD_DOMAINS=$(grep ^ADD_DOMAINS= "$ENVFILE" | awk -F= '{ print $NF }')

DBA_USER=$(grep ^DBA_USER= "$ENVFILE" | awk -F= '{ print $NF }')
DBA_PASSWORD=$(grep ^DBA_PASSWORD= "$ENVFILE" | awk -F= '{ print $NF }')

# To be constructed repo specific
echo "VHOSTS_ACCOUNTS=welcome.$DOMAIN" >> "$ENVFILE"
echo "SMTP_FROM=welcome@$DOMAIN" >> "$ENVFILE"

# generate basic auth for phpmyadmin
htpasswd -c  -b /mnt/docker/nginx/passwds/pma.htpasswd $DBA_USER "$DBA_PASSWORD"

VIRTUAL_HOST=$(echo "$ADD_DOMAINS" | tr "," "\n" | while read line; do echo "autoconfig.$line,autodiscover.$line"; done | tr "\n" "," | sed 's/.$//g')

echo "VIRTUAL_HOST=$VIRTUAL_HOST" >> "$ENVFILE"

# finished .env file generation

rm -f letsencrypt/autorenew/ssl-domains.dat
# fille autorenew config
echo "$VIRTUAL_HOST,dba.$DOMAIN,drive.$DOMAIN,mail.$DOMAIN,office.$DOMAIN,spam.$DOMAIN,webmail.$DOMAIN,welcome.$DOMAIN" | tr "," "\n" | while read CURDOMAIN; do
    echo "sub        $CURDOMAIN" >> letsencrypt/autorenew/ssl-domains.dat
:; done
cat letsencrypt/autorenew/template-ssl-renew.sh | sed "s/@@@DOMAIN@@@/$DOMAIN/g" > letsencrypt/autorenew/ssl-renew.sh


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
cat nginx/templates/office | sed "s/@@@DOMAIN@@@/$DOMAIN/g" > "nginx/sites-enabled/office.$DOMAIN.conf"
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
echo "mail.$DOMAIN A record to your public IP"
echo "PTR record for your public IP towards mail.$DOMAIN.com (reverse DNS to match A record above)"
echo ""
echo "$VIRTUAL_HOST,dba.$DOMAIN,drive.$DOMAIN,office.$DOMAIN,spam.$DOMAIN,webmail.$DOMAIN,welcome.$DOMAIN" | tr "," "\n" | while read CURDOMAIN; do
    echo "CNAME record $CURDOMAIN towards mail.$DOMAIN."
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

# Run LE cert request
sh letsencrypt/autorenew/ssl-renew.sh


# verify LE status
CTR_LE=$(find letsencrypt/certstore/live/dba.$DOMAIN/privkey.pem  letsencrypt/certstore/live/drive.$DOMAIN/privkey.pem letsencrypt/certstore/live/mail.$DOMAIN/privkey.pem letsencrypt/certstore/live/office.$DOMAIN/privkey.pem letsencrypt/certstore/live/spam.$DOMAIN/privkey.pem letsencrypt/certstore/live/webmail.$DOMAIN/privkey.pem  letsencrypt/certstore/live/welcome.$DOMAIN/privkey.pem 2>/dev/null| wc -l)
CTR_AC_LE=$(echo "$VIRTUAL_HOST" | tr "," "\n" | while read CURDOMAIN; do find letsencrypt/certstore/live/$CURDOMAIN/privkey.pem 2>/dev/null | grep $CURDOMAIN && echo found || echo missing; done  | grep missing | wc  -l)

if [ "$CTR_LE$CTR_AC_LE" = "70" ]
then
    echo "All LE certs present."
    echo "Reboot server now."
else
    echo "Verification of LE status failed. Some expected certificates are missing"
    echo "$CTR_LE of 7 certifcates found."
    echo "$CTR_AC_LE autoconfig/autodiscovery certificates are missing."
    exit 1
fi

# Login to /e/ registry | not necessary when going public
#docker login registry.gitlab.e.foundation:5000

#cd /mnt/docker/
#docker-compose -f docker-compose-autogen.yml up -d

# display DNS setup info and PW infos