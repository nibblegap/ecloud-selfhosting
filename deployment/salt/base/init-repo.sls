include:
  - docker-compose
init-repo:
  cmd.run:
    - name: cd /mnt/docker && sh init-repo.sh
    - require:
      - service: docker-running
