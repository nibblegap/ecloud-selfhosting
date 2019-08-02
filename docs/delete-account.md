Delete User Cccount
-------------------

1. Delete email account and data
    - login to mail.$DOMAIN
    - click on domain list
    - select the correct domain
    - search for the username on the top right
    - delete the correct account

2. delete nextcloud files and data
    - Note: we need to delete this manually at the moment, maybe it will work automatically with the user_external plugin.
    - `ssh user@$DOMAIN`
    - `cd /mnt/repo-base/`
    - `sudo rm -r volumes/nextcloud/data/user@$DOMAIN/`
    - `sudo docker-compose exec mariadb mysql -u root -p`
    - `use nextcloud;`
    - `DELETE FROM calendars WHERE principaluri='principals/users/user@$DOMAIN';`
    - `DELETE FROM addressbooks WHERE principaluri='principals/users/user@$DOMAIN';`

4. onlyoffice data
    - go to [https://office.$DOMAIN/products/people/#sortorder=ascending](https://office.$DOMAIN/products/people/#sortorder=ascending)
    - search for the username
    - click on the arrow at the far right and press "Delete profile"
