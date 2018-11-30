## DNS prerequisite
- Add CNAME entry for your new vhost to point to "mail.ecloud.global."

## Login
ssh root@mail.ecloud.global

## Execute the script commands below manually verifying each step (not well tested yet)
```shell

# Tweak variable to your needs
NEWVHOST=thilo-test.ecloud.global


# Request cert from LE
echo -e "sub\t$NEWVHOST" >> /mnt/docker/letsencrypt/autrenew/ssl-domains.dat
/mnt/docker/letsencrypt/autrenew/ssl-renew.sh


# Add vhost to docker-compose configuration
sed -i "s@VHOSTS_DOMAINS=@VHOSTS_DOMAINS=$NEWVHOST,@g" /mnt/docker/compose/.env


# Create dir to host php files
mkdir -p /mnt/docker/www/$NEWVHOST/htdocs/

# Create nginx proxy vhost to point to dockered vhost
echo "server {
  listen 8000;
  server_name ${NEWVHOST};
  return 301 https://\$host\$request_uri;
}
server {
  listen 4430 ssl http2;
  server_name ${NEWVHOST};
  ssl_certificate /certs/live/${NEWVHOST}/fullchain.pem;
  ssl_certificate_key /certs/live/${NEWVHOST}/privkey.pem;
  include /etc/nginx/conf/ssl_params;
  include /etc/nginx/conf/headers_params;
  location / {
    add_header Content-Security-Policy upgrade-insecure-requests always;
    proxy_pass http://vhosts:80;
    include /etc/nginx/conf/proxy_params;
  }
}" > /mnt/docker/nginx/sites-enabled/${NEWVHOST}.conf

# Place file to check it is working
echo "hello world" > /mnt/docker/www/$NEWVHOST/htdocs/index.php
chown www-data: /mnt/docker/www/$NEWVHOST/ -R

# Restart services to bring changes into effect
cd /mnt/docker/compose && docker-compose up -d
docker restart nginx
```

## Final checks
Health check:
- Is this still working or did we break something: https://webmail.ecloud.global/
- Is new host working? https://thilo-test.ecloud.global

# Happy hacking
Update you code in /mnt/docker/www/$NEWVHOST/htdocs/ to your liking :)

Enjoy!