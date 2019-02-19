Files and Folders
-------

- `config-dynamic/` Config files that are generated based on templates, and contain hardcoded values like the local domain

- `config-static/` Config files that are included with the git repo and don't change (except in repo updates)

- `deployment/` Files that are required for the initial installation

- `docs/` General project documentation

- `scripts/` Various scripts that are used for installation, updating and administration

- `templates/` Used to dynamically generate various config files

- `volumes/` Docker volumes used to store data for the different applications (eg Nextcloud files, mail data)

- `.env` Defines passwords and other variables (see [env_file.md](env_file.md) for details)

- `docker-compose.yml` Defines the Docker images and volumes. Run `docker-compose up -d` to start the services, and `docker-compose down` to stop them.
