upgrade-all:
  pkg.uptodate:
    - name: update
    - refresh: true
  cmd.run:
    - name: apt-get -y upgrade -o Dpkg::Options::="--force-confold" && apt-get -y autoremove
    - shell: /bin/bash

install-deps:
  pkg.installed:
    - name: apt-transport-https
    - name: ca-certificates
    - name: curl
    - name: software-properties-common
    - name: apache2-utils
    - name: docker
    - name: docker-compose
    - require:
      - upgrade-all

docker-running:
  service.running:
    - name: docker
    - enable: true
    - require:
      - install-deps

cron-renew-ssl-certs:
  cron.present:
    - name: bash /mnt/repo-base/scripts/ssl-renew.sh
    - user: root
    - special: '@daily'
    - identifier: 'refresh-tls-certs'

cron-check-updates:
  cron.present:
    - name: bash /mnt/repo-base/scripts/check-update.sh
    - user: root
    - special: '@daily'
    - identifier: 'check-updates'
