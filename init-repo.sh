#!/bin/bash
cd /mnt/docker && grep mnt docker-compose.yml  | grep -v \# | awk '{ print $2 }' | awk -F: '{ print $1 }' | sed 's@m/.*conf$@m@g' | grep -v id_rsa | while read line; do dirname $line; done | sort -u | while read line; do mkdir -p "$line"; done
cp env-example .env
