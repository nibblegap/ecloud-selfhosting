# base installation

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
    - name: docker.io
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

/etc/docker/daemon.json:
  file.managed:
    - source: salt://docker-daemon.json
    - user: root
    - group: root
    - mode: 644

# security hardening

haveged:
  pkg.installed

net.ipv4.icmp_ratelimit:
  sysctl.present:
    - value: 100

net.ipv4.icmp_ratemask:
  sysctl.present:
    - value: 88089

net.ipv4.tcp_rfc1337:
  sysctl.present:
    - value: 1

login_defs1:
  file.replace:
    - name: /etc/login.defs
    - repl: UMASK           027
    - pattern: ^UMASK .*
    - append_if_not_found: True
login_defs2:
  file.replace:
    - name: /etc/login.defs
    - repl: PASS_MIN_DAYS   7
    - pattern: ^PASS_MIN_DAYS .*
    - append_if_not_found: True
