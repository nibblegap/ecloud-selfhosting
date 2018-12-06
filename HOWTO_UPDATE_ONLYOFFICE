1,5,7,8
DE30600908000004489812


# UPDATE PROCEDURE (expect downtime)

```shell
# this is knowingly not using compose functionality to stop/rm/pull

# Stop containers
docker stop onlyoffice-community-server
docker stop onlyoffice-document-server
docker stop onlyoffice-mail-server

#Create backup copy of files
cp -pR /mnt/docker/onlyoffice{,.bck}

# Save image IDs of old images to a file
docker images | grep office > /somewhere/a-file.txt


docker rm onlyoffice-community-server
docker rm onlyoffice-document-server
docker rm onlyoffice-mail-server

docker pull onlyoffice/documentserver
docker pull onlyoffice/communityserver
docker pull onlyoffice/mailserver

# Start again
cd /mnt/docker/compose
docker-compose up -d
```

# ROLLBACK IN CASE OF ISSUE (expect downtime)

```shell
# Stop and delete containers as above

# Delete new images
docker rmi onlyoffice/documentserver
docker rmi onlyoffice/communityserver
docker rmi onlyoffice/mailserver

# Retag the previous images version (see a-file.txt) IMAGE iDs to the correct name, e.g.:
docker tag 9a77d093202e onlyoffice/documentserver
docker tag 0e667b917252 onlyoffice/communityserver
dockr tag  6b2398f473ea onlyoffice/mailserver 

# Move current files to yet another location and move previous backup into original location
mv /mnt/docker/onlyoffice /mnt/docker/onlyoffice.bck.rolledback
mv /mnt/docker/onlyoffice.bck /mnt/docker/onlyoffice

# Start again
cd /mnt/docker/compose
docker-compose up -d
```