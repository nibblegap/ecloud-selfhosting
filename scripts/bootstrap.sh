#!/bin/bash

################################################################################
apt-get update && apt install -y --asume-yes true git salt-minion
################################################################################


# Init salt-minion (masterless)
cp /mnt/repo-base/deployment/salt/init-config/masterless.conf /etc/salt/minion.d/

# Run repo init (might run a few minutes)
echo "System update and packages installation .."
salt-call state.apply docker-compose


# init repo
bash /mnt/repo-base/scripts/init-repo.sh $ENVIRONMENT
