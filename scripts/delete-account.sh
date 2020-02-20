#!/bin/bash
set -e

source /mnt/repo-base/scripts/base.sh

echo "Enter the email address to be deleted:"
read ACCOUNT

if ! docker-compose exec -T -u www-data nextcloud php occ user:info "$ACCOUNT" | grep "$ACCOUNT" --quiet; then
    echo "Error: The account $ACCOUNT does not exist"
    exit
fi

echo "Please confirm to delete the user account $ACCOUNT including all data. This is not reversible."
read -r -p "[y/N] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "Deleting Nextcloud account"
    docker-compose exec -T -u www-data nextcloud php occ user:delete "$ACCOUNT"

    echo "Deleting email account"
    docker-compose exec -T postfixadmin /postfixadmin/scripts/postfixadmin-cli mailbox delete "$ACCOUNT"

    # Fix #951
    # 2 files to update auth.file.done and auth.file
    FILE_MULTIPLE_REGISTRATION_CHECK=/mnt/repo-base/volumes/accounts/auth.file.done
    AUTH_FILE=/mnt/repo-base/volumes/accounts/auth.file
    
    # delete line with $ACCOUNT : this is a  e.email
    # strip "e.email" suffix to get mbox
    MBOX=${ACCOUNT%"@e.email"}

    echo "Updating system persistent info"
    # grep |wc -l >> count result, if one line found in auth.file.done, delete it
    if [[ $(grep -R "\:$MBOX$" $FILE_MULTIPLE_REGISTRATION_CHECK |wc -l) = "1" ]]; then
    		
    		# Grab mail used to register from the line (to be used for $AUTH_FILE update in #2)
    		MAIL_USED=$(grep -R "\:$MBOX$" $FILE_MULTIPLE_REGISTRATION_CHECK| cut -f1 -d":")
        	        	
        	echo "#1 Removing $MBOX from file $FILE_MULTIPLE_REGISTRATION_CHECK"
        	# sed pattern : \:$MBOX$ = line ending with $MBOX ($), and ':' before $MBOX to prevent accidental deletion 
        	# ex : if $MBOX = doe do NOT delete all lines ending with "doe", "johndoe", "john-doe", only delete ":doe"
        	sed -i "/\:$MBOX$/d" $FILE_MULTIPLE_REGISTRATION_CHECK

        	echo "#2 Deleting all lines with $MAIL_USED found in $AUTH_FILE"
        	# sed pattern : ^$MAIL_USED\: = line starting with $MAIL_USED (^), and ':' after $MAIL_USED to encapsulate it
        	sed -i "/^$MAIL_USED\:/d" $AUTH_FILE

	elif [[ $(grep -R "\:$MBOX$" $FILE_MULTIPLE_REGISTRATION_CHECK |wc -l) = "0" ]]
	then
	        echo "$MBOX not found in $FILE_MULTIPLE_REGISTRATION_CHECK"
	else
	        echo "More than one line to be deleted for $MBOX, check $FILE_MULTIPLE_REGISTRATION_CHECK please"
	fi


    # TODO: delete onlyoffice account???
fi
