# Howto setup a PoC of mail/drive/office/accounts/webmail

apt-get update && apt install -y git
git -C /mnt clone https://gitlab.e.foundation/e/priv/cloud/compose.git
ln -s /mnt/compose/ /mnt/docker

if folder not checked out with:
[grep mnt docker-compose.yml  | grep -v \# | awk '{ print $2 }' | awk -F: '{ print $1 }' | sed 's@m/.*conf$@m@g' | grep -v id_rsa| sort -u | while read line; do mkdir -p "$line"; done]

to be continued...