#!/bin/bash
#source <(curl -s https://gitlab.e.foundation/e/cloud/bootstrap/raw/master/bootstrap-commons.sh)

# Create folder structure
#cd /mnt/docker
#cd /mnt/docker && grep mnt docker-compose-autogen.yml  | grep -v \# | awk '{ print $2 }' | awk -F: '{ print $1 }' | sed 's@m/.*conf$@m@g' | grep -v id_rsa | while read line; do dirname $line; done | sort -u | while read line; do mkdir -p "$line"; done

#ENVFILE="/mnt/docker/.env"
ENVFILE=".env"
rm -f "$ENVFILE"

#########
function getRandomString {
        LENGTH=$1
        cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $LENGTH | head -n 1
}

function replaceTokensWithRandomStrings {
        INPUT="$1"
        TOBEREPLACED=$(echo "$INPUT" | grep -o '@@@generate@@@:[0-9]\+@')
        REPLACEMENT_LENGTH=$(echo "$TOBEREPLACED" | awk -F: '{ print $NF }' | sed 's/@$//g')
        RANDOMPART=$(getRandomString $REPLACEMENT_LENGTH)
        echo "$INPUT" | sed "s/$TOBEREPLACED/$RANDOMPART/g"
}
function doReplacementIfNecessary {
    VALUE="$1"
    echo "$VALUE" | grep -q "@@@generate@@@" && replaceTokensWithRandomStrings "$VALUE" || echo "$VALUE"
}
#########

# Create .env file

while read KEY VALUE; do
    PREVVALUE="$VALUE"
    VALUE=$(doReplacementIfNecessary "$VALUE")
    if [ "$PREVVALUE" = "$VALUE" ]
    then
        if [[ "$#" -ne 1 ]]
        then
            echo "$VALUE"
            read INPUT < /dev/tty
            echo "$KEY=$INPUT" >> "$ENVFILE"
         else
            ANSWERFILE="deployment/questionnaire/answers.dat"
            VALUE=$(grep "^$KEY=" "$ANSWERFILE" | awk -F= '{ print $NF }')
            echo "$KEY=$VALUE" >> "$ENVFILE"
         fi
     else
        echo "$KEY=$VALUE" >> "$ENVFILE"
     fi
:;done <<< "$(grep -v \# deployment/questionnaire/questionnaire.dat | sed '/^$/d'| sed 's/=/        /g')"

DOMAIN=$(grep ^DOMAIN= "$ENVFILE" | awk -F= '{ print $NF }')
ADD_DOMAINS=$(grep ^ADD_DOMAINS= "$ENVFILE" | awk -F= '{ print $NF }')

# To be constructed repo specific
echo "VHOSTS_ACCOUNTS=welcome.$DOMAIN" >> "$ENVFILE"
echo "SMTP_FROM=welcome@$DOMAIN" >> "$ENVFILE"

VIRTUAL_HOST=$(echo "$ADD_DOMAINS" | tr "," "\n" | while read line; do echo "autoconfig.$line,autodiscover.$line"; done | tr "\n" "," | sed 's/.$//g')

echo "VIRTUAL_HOST=$VIRTUAL_HOST" >> "$ENVFILE"

# finished .env file generation

# fille autrenew config
echo "$VIRTUAL_HOST,dba.$DOMAIN,drive.$DOMAIN,mail.$DOMAIN,office.$DOMAIN,spam.$DOMAIN,webmail.$DOMAIN,welcome.$DOMAIN" | tr "," "\n" | while read CURDOMAIN; do
    echo "sub        $CURDOMAIN" >> letsencrypt/autrenew/ssl-domains.dat
:; done
cat letsencrypt/autrenew/template-ssl-renew.sh | sed "s/@@@DOMAIN@@@/$DOMAIN/g" > letsencrypt/autrenew/ssl-renew.sh
#tbd


# Configure automx
cat automx/automx-template.conf | sed "s/@@@DOMAIN@@@/$DOMAIN/g" > automx/automx.conf

# Configure nginx vhost

# automx
echo "$DOMAIN,$ADD_DOMAINS" | tr "," "\n" | while read CURDOMAIN; do
    cat nginx/templates/autoconfig | sed "s/@@@DOMAIN@@@/$CURDOMAIN/g" | sed "s/@@@SERVICE@@@/autoconfig/g" > nginx/sites-enabled/autoconfig.$CURDOMAIN.conf
    cat nginx/templates/autoconfig | sed "s/@@@DOMAIN@@@/$CURDOMAIN/g" | sed "s/@@@SERVICE@@@/autodiscover/g" > nginx/sites-enabled/autodiscover.$CURDOMAIN.conf
:; done

# other hosts
cat nginx/templates/dba | sed "s/@@@DOMAIN@@@/$CURDOMAIN/g" > "nginx/sites-enabled/dba.$DOMAIN.conf"
cat nginx/templates/drive | sed "s/@@@DOMAIN@@@/$CURDOMAIN/g" > "nginx/sites-enabled/drive.$DOMAIN.conf"
cat nginx/templates/mail | sed "s/@@@DOMAIN@@@/$CURDOMAIN/g" > "nginx/sites-enabled/mail.$DOMAIN.conf"
cat nginx/templates/office | sed "s/@@@DOMAIN@@@/$CURDOMAIN/g" > "nginx/sites-enabled/office.$DOMAIN.conf"
cat nginx/templates/spam | sed "s/@@@DOMAIN@@@/$CURDOMAIN/g" > "nginx/sites-enabled/spam.$DOMAIN.conf"
cat nginx/templates/webmail | sed "s/@@@DOMAIN@@@/$CURDOMAIN/g" > "nginx/sites-enabled/webmail.$DOMAIN.conf"
cat nginx/templates/welcome | sed "s/@@@DOMAIN@@@/$CURDOMAIN/g" > "nginx/sites-enabled/welcome.$DOMAIN.conf"



# Generate DKIM stuff in advance for DNS infor block...
# tbd


# display DNS setup info
# confirm DNS is ready

/mnt/docker/letsencrypt/autrenew/ssl-renew.sh
cd /mnt/docker/
docker-compose -f docker-compose-autogen.yml

# display final message
