include:
  - docker-compose
init-repo:
  cmd.run:
    - name: cd /mnt/docker && bash init-repo.sh
    - require:
      - service: docker-running
