Delete User Cccount
-------------------

1. Delete email account, Nextcloud account and all data
    - `ssh user@$DOMAIN`
    - `cd /mnt/repo-base/`
    - `sudo ./scripts/delete-account $USER`

2. onlyoffice data
    - go to [https://office.$DOMAIN/products/people/#sortorder=ascending](https://office.$DOMAIN/products/people/#sortorder=ascending)
    - search for the username
    - click on the arrow at the far right and press "Delete profile"
