Delete User Cccount
-------------------

1. Delete email account and data
    - login to mail.$DOMAIN
    - click on domain list
    - select the correct domain
    - search for the username on the top right
    - delete the correct account

2. delete nextcloud account
    - `ssh user@$DOMAIN`
    - `cd /mnt/repo-base/`
    - `sudo docker-compose exec -u www-data nextcloud php occ user:delete user@$DOMAIN`

4. onlyoffice data
    - go to [https://office.$DOMAIN/products/people/#sortorder=ascending](https://office.$DOMAIN/products/people/#sortorder=ascending)
    - search for the username
    - click on the arrow at the far right and press "Delete profile"
