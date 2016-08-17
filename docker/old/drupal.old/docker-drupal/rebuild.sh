#!/bin/bash
sudo docker stop $(sudo docker ps -q)
sudo docker rm $(sudo docker ps -a -q)
sudo docker rmi -f $(docker images -q)
# Example script for testing container variants

name=mediadb09
domain=entermediadb.net
image=boran/drupal:emdb

# Delete tmp files
rm -rf /tmp/drupal800*
# If developing the mother image
docker build -t="$image" .

## Enable one of the following test cases ##

echo ">> $name: Simple case Http://localhost:8000 from $image"
#docker run -d -t -p 8003:80  -e "VIRTUAL_HOST=$name.$domain" --name $name $image

echo ">> $name:  Mount webroot and /data as a volume"
mkdir /tmp/drupal8003/www /tmp/drupal80003/data 2>/dev/null
# docker run -d -t -p 8003:80 -v /tmp/drupal8003/www:/var/www/html -v /tmp/drupal80003/data:/data  -e "VIRTUAL_HOST=$name.$domain" --name $name $image


#docker run -d -t -p 8003:80 -e "DRUPAL_NONE=skip" -e "DRUPAL_INSTALL_PROFILE=standard" -e "VIRTUAL_HOST=$name.$domain" --name $name $image
# -e "DRUPAL_NONE=skip"
# -e "DRUPAL_FINAL_CMD=drush -y dl prod_check && drush -y en prod_check && drush -y cache-clear drush && drush -y prod-check-prodmode"
# -e "VIRTUAL_HOST=$name.$domain"

#DRUPAL_GIT_REPO
#docker run -dt -p 8003:80 -e "VIRTUAL_HOST=drupal8003.$domain" -e "DRUPAL_GIT_REPO=https://bob:bobpasswd@bitbucket.org/some/repo" --restart=always --hostname drupal8003 --name drupal8003 $image

#DRUPAL_MAKE_REPO
#docker run -td -p 8003:80 -e "DRUPAL_MAKE_DIR=drupal-make1" -e "DRUPAL_MAKE_REPO=https://github.com/Boran/drupal-make1" -e 'DRUPAL_INSTALL_PROFILE=standard' --hostname drupal8003 --name drupal8003 $image

# other options
# --restart=always

## DRUPAL_GIT_SSH
#docker run -ti -p 8003:80 -e "DRUPAL_GIT_SSH=/gitwrap.sh" -e "DRUPAL_GIT_REPO=git@bitbucket.org:/innoveto/swisscom-site-factory.git" -v /root/boran-drupal/ssh/id_rsa:/root/gitwrap/id_rsa -v /root/boran-drupal/ssh/id_rsa.pub:/root/gitwrap/id_rsa.pub -v /root/boran-drupal/ssh/known_hosts:/root/gitwrap/known_hosts --restart=always --hostname drupal8003 --name drupal8003 boran/drupal /bin/bash


docker logs -f $name


