#!/usr/bin/env bash
if [ "$(whoami)" != "root" ]
then
        exit 1
fi

MAILHOST="mail.@@@DOMAIN@@@"
CONFIG=/mnt/docker/letsencrypt/autrenew/ssl-domains.dat
OPENSSLBIN=/usr/bin/openssl
CERTSTOREBASE=/mnt/docker/letsencrypt/certstore
CERTSTORE=$CERTSTOREBASE/live
SERVERADMIN=admin@@@@DOMAIN@@@
PUBIP=0.0.0.0

cat "$CONFIG" | while read TYPE DOMAIN; do
        ALIAS=""
        if [ "$TYPE" = "main" ]
        then
                ALIAS="-d www.$DOMAIN"
        fi
        if [ -f $CERTSTORE/$DOMAIN/fullchain.pem ]
        then
                EXPIRESWITHINNEXT7DAYS=$($OPENSSLBIN x509 -checkend 604800 -noout -in $CERTSTORE/$DOMAIN/fullchain.pem && echo 0 || echo 1)
                VALIDTHRU=$($OPENSSLBIN x509 -enddate -noout -in $CERTSTORE/$DOMAIN/fullchain.pem | awk -F= '{ print $NF }')
        else
                echo "Initial certificate request for $DOMAIN"
                EXPIRESWITHINNEXT7DAYS=1
                VALIDTHRU="undefined"
        fi
        #echo "Certificate for $DOMAIN renewed and is valid until: $VALIDTHRU"
        if [ "$EXPIRESWITHINNEXT7DAYS" = "1" ]
        then
                docker stop nginx
                #docker ps
		#echo "docker run -t --rm -v $CERTSTOREBASE:/etc/letsencrypt -p $PUBIP:80:80 -p $PUBIP:443:443 xataz/letsencrypt certonly --standalone --agree-tos -m $SERVERADMIN -d $DOMAIN $ALIAS"
		        docker run -t --rm -v $CERTSTOREBASE:/etc/letsencrypt -p $PUBIP:80:80 -p $PUBIP:443:443 xataz/letsencrypt certonly --standalone --agree-tos -m $SERVERADMIN -d $DOMAIN $ALIAS
                docker start nginx
                NVALIDTHRU=$($OPENSSLBIN x509 -enddate -noout -in $CERTSTORE/$DOMAIN/fullchain.pem | awk -F= '{ print $NF }')
                echo "Certificate for $DOMAIN renewed and is valid until: $NVALIDTHRU (was: $VALIDTHRU)"
        	if [ "$DOMAIN" = "$MAILHOST" ]
        	then
			    cd /mnt/docker/compose
        	    docker-compose restart eelomailserver
			    cd -
        	fi
#       else
#               echo "Certificate for $DOMAIN is valid for more than 7 days: $VALIDTHRU"
        fi
:;done