# Requirements

For the full setup, the following server hardware is recommended:

- 2 core CPU
- 4 GB RAM
- 20 GB disk space

For the setup without OnlyOffice, requirements are a bit lower:

- 1 core CPU
- 2 GB RAM
- 15 GB disk space

Disk space only refers to the basic installation. You will need additional space for any emails,
documents and files you store on the server.

### Required packages in server (these should be included with Ubuntu by default)
- curl
- bash
- python3

### Other Requirements
- A user with root access or root user.
- Server must have ssh setup and accessible through ssh key based authentication
- Server must be accessible through a public ip.
- A Domain name for your server.

# Installation

## Create Ubuntu VM & set reverse DNS
This examplpes uses Hetzner cloud.
You can use whatever provider you want. Just make sure to set rdns correctly before running the
bootstrap script (works via Webui with some other hosters)
```
$ hcloud server create --image=ubuntu-18.04 --name server1 --type cx31 --ssh-key ts@treehouse-sss
$ hcloud server set-rdns server1 --hostname mail.example.com
```

## Setup the server
The playbook can be run directly on the server or in your personal computer (must have access to server via ssh key based authentication).

1. Install ansible in the server/personal computer. (For Ubuntu 18.04)
    ```bash
    sudo apt-get update
    sudo apt-get install ansible
    ``` 

2. Download the anisble playbook sources in server/personal computer
    ```bash
    git clone -b ansible https://gitlab.e.foundation/e/priv/infra/compose ansible-ecloud
    ```

3. Edit the `hosts` file and replace `<domain name>` with your registered domain name, `<ip-address>` with your public ip address and `<root user>` with the user with root access.
    ```bash
    <domain-name> ansible_host=<ip-address> ansible_ssh_user=<root-user> ansible_ssh_pipelining=yes ansible_python_interpreter=/usr/bin/python3
    ```

4. Edit the `group_vars/all` configuration file and specify 
- `ecloud_domain` - with your registered domain name (Required)
- `ecloud_additional_domains` - specify if you want additional domains as email alias. (Optional)
- `user_alternate_email_for_signup` - your personal email id (Required)
- `ecloud_install_onlyoffice` - set it `true` if you want to install onlyoffice, else `false` (Required, Default: false)
- `ecloud_gitlab_docker_repo_user` - specify your e-foundation gitlab username (Required, until the repo is made public)
- `ecloud_gitlab_docker_repo_password` - specify your e-foundation gitlab password (Required, until the repo is made public)
    ```bash
    ecloud_domain: "<domain-name>"
    ecloud_additional_domains: []
    user_alternate_email_for_signup: "<user-email>"
    ecloud_install_onlyoffice: false
    ecloud_gitlab_docker_repo_user: "<e-foundation-gitlab-username>"
    ecloud_gitlab_docker_repo_password: "<e-foundation-gitlab-password>"
    ...
    ...
    ...
    ```

4. Run the playbook to setup up and start your own ecloud server!
    ```bash
    ansible-playbook -i hosts ecloud.yml --tags=setup
    ```

5. **Follow the installation and make sure the DNS records are created with your domain registrar as mentioned during execution.**

6. That's it. If everything goes well, the server must be all set. 

### **Important** : 
1. Note down the DKIM DNS record, admin credentials for spam management, e-drive(Nextcloud), Mail server management (Postfixadmin), and **the new user sign up url**. 
2. Open the sign up url to create your first ecloud-server account!
3. All credentials are stored as plain-text in the `credentials/` directory. Take the necessary step secure it.
(Preferrably, user can use ansible-vaults to secure them and replace the the password values in `group_vars/all` with the encrypted value)

# Additional Options

## Generate Sign Up URL for new user
```bash
ansible-playbook -i hosts ecloud.yml --tags=generate_signup_link --extra-vars="new_user_email=<new-user-email-id>"
```

## Start/Stop all services
```bash
# For Stopping
ansible-playbook -i hosts ecloud.yml --tags=stop
# For Starting
ansible-playbook -i hosts ecloud.yml --tags=start
```

## View DNS configuration
```bash
ansible-playbook -i hosts ecloud.yml --tags=dns-configure
```

## View Admin Credentials
```bash
ansible-playbook -i hosts ecloud.yml --tags=admin-credentials
```

## View DKIM DNS Record
```bash
ansible-playbook -i hosts ecloud.yml --tags=dkim-record
```



