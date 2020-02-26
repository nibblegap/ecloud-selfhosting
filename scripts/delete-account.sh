#!/bin/bash
set -e

source /mnt/repo-base/scripts/base.sh

echo "Enter the email address to be deleted:"
read ACCOUNT

# strip @ANDEVERYTHINGAFTER suffix to get mbox only
MBOX=${ACCOUNT%%@*}
# strip EVERYTHINGBEFOREAND@ prefix to get domain only
MAIL_DOMAIN=${ACCOUNT##*@}

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

    # remove user's maildir as postfixadmin-cli mailbox delete "$ACCOUNT" is not doing it
    MAILDIR="/mnt/repo-base/volumes/mail/vhosts/$MAIL_DOMAIN/$MBOX"

    if [[ -n "$MBOX" && -n "$MAIL_DOMAIN" ]]; then
    	# double check on $MBOX and $MAIL_DOMAIN not empty
    	# as we don't want to remove entire /mnt/repo-base/volumes/mail/vhosts/ !!
    	if [ -d $MAILDIR ]; then
		    echo "Deleting email folder in $MAILDIR for this account"
    		rm -rf $MAILDIR
    	else
    		echo "$MAILDIR does not exit"
    	fi
    fi
    

    # 2 files to update auth.file.done and auth.file
    AUTH_FILE_DONE=/mnt/repo-base/volumes/accounts/auth.file.done
    AUTH_FILE=/mnt/repo-base/volumes/accounts/auth.file
    
    # delete line with $ACCOUNT : @ACCOUNT is a $MBOX@DOMAIN
    # strip @ANDEVERYTHINGAFTER suffix to get mbox only, to be more generic
    MBOX=${ACCOUNT%%@*}

    echo "Updating system persistent info"
    NB_LINES = $(grep -R "\:$MBOX$" $AUTH_FILE_DONE |wc -l)
    # if ONLY one line found in auth.file.done, delete it
    if [[ $NB_LINES = "1" ]]; then
    		
    		# Grab mail used to register from the line (to be used for $AUTH_FILE update in #2)
    		MAIL_USED=$(grep -R "\:$MBOX$" $AUTH_FILE_DONE| cut -f1 -d":")
        	        	
        	echo "#1 Removing $MBOX from file $AUTH_FILE_DONE"
        	# sed pattern : \:$MBOX$ 
        	# use $ after $MBOX to get line ending with $MBOX, 
        	# ':' before $MBOX to prevent accidental deletion 
        	# ex : if $MBOX = doe  only delete line ending with ":doe"
        	# do NOT delete all lines ending with ":doe", ":johndoe" or ":john-doe"
        	sed -i "/\:$MBOX$/d" $AUTH_FILE_DONE

        	echo "#2 Deleting all lines with $MAIL_USED found in $AUTH_FILE"
        	# sed pattern : ^$MAIL_USED\: 
        	# use ^ before $MAIL_USED to get only line STARTING WITH $MAIL_USED, 
        	# ':' after $MAIL_USED to encapsulate it		
        	sed -i "/^$MAIL_USED\:/d" $AUTH_FILE

	elif [[ $NB_LINES = "0" ]]
	then
	        echo "$MBOX not found in $AUTH_FILE_DONE"
	else
	        echo "More than one line to be deleted for $MBOX, check $AUTH_FILE_DONE please"
	fi


    # TODO: delete onlyoffice account???



fi
