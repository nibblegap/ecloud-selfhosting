#!/usr/bin/env bash
OC_PASS="$2" su -s /bin/sh www-data -c "/usr/local/bin/php occ user:add --group=\"admin\" --password-from-env $1"
rm -f $0