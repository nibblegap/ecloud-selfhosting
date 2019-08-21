upgrade-all:
  pkg.uptodate:
    - name: update
    - refresh: true
  cmd.run:
    - name: apt-get -y upgrade -o Dpkg::Options::="--force-confold" && apt-get -y autoremove
    - shell: /bin/bash

install-deps:
  pkg.installed:
    - pkgs:
      - apt-transport-https
      - ca-certificates
      - curl
      - software-properties-common
      - apache2-utils
      - docker.io
      - docker-compose
      - gnupg2
      - pass
      - certbot
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
    - name: bash /mnt/repo-base/scripts/ssl-renew.sh >> /mnt/repo-base/volumes/letsencrypt/letsencrypt-cron.log 2>&1
    - user: root
    - special: '@daily'
    - identifier: 'refresh-tls-certs'

cron-check-updates:
  cron.present:
    - name: bash /mnt/repo-base/scripts/check-update.sh
    - user: root
    - special: '@daily'
    - identifier: 'check-updates'

cron-sync-emails:
  cron.present:
    - name: bash /mnt/repo-base/scripts/sync-emails.sh
    - user: root
    - special: '@hourly'
    - identifier: 'sync-emails'

/etc/docker/daemon.json:
  file.managed:
    - source: salt://docker-daemon.json
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
