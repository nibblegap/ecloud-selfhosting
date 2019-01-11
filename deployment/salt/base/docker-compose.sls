upgrade-all:
  pkg.uptodate:
    - name: update
    - refresh: true
  cmd.run:
    - name: apt -y upgrade -o Dpkg::Options::="--force-confold" && apt -y autoremove
    - shell: /bin/bash
install-deps:
  pkg.installed:
    - name: apt-transport-https
    - name: ca-certificates
    - name: curl
    - name: software-properties-common
    - name: apache2-utils
    - require:
      - upgrade-all
import-docker-key-repos:
  cmd.run:
    - name: curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs) stable"
    - shell: /bin/bash
    - require:
      - install-deps

install-compose:
  cmd.run:
    - name: if [ ! -f /usr/local/bin/docker-compose ]; then curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose; fi
    - shell: /bin/bash
    - require:
      - install-docker

install-docker:
  pkg.installed:
    - name: docker-ce
    - require:
      - import-docker-key-repos

docker-running:
  service.running:
    - name: docker
    - enable: true
    - require:
      - install-docker

