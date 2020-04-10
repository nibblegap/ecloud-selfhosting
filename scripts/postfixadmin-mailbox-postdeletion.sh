#!/bin/sh

# Script for removing a mailbox dir in ecloud

# The script looks at arguments 1 and 2, assuming that they 
# indicate username and domain, respectively.


# the script is actually run by the pfexec user
# the script handles deletion in a bind-mounted dir shared with eelomailserver
# so pfexec user has no right over it. it needs a specific sudo perm 
#to be able to only run this script
# the /etc/sudoers line added to the container during install :
# pfexec ALL=(root) NOPASSWD: /usr/local/bin/postfixadmin-mailbox-postdeletion.sh
# The line states that the pfexec user may run the script without providing a password.


# where the mailbox dirs are bind-mounted on the container.
basedir=/var/mail/vhosts

if [[ -n "$1" && -n "$2" ]]; then
    # double check both arguments are provided

    if [ `echo $1 | fgrep '..'` ]; then
        # not permitted!!
        exit 1
    fi
    if [ `echo $2 | fgrep '..'` ]; then
        # not permitted!!
        exit 1
    fi

    
    maildir="${basedir}/$2/$1"



    if [ ! -e "$maildir" ]; then
        # not maildir empty, doing nothing
        exit 0
    fi


    rm -rf $maildir
else 
    # args are empty, do nothing
    exit 1
fi   

exit $?