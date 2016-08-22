#!/bin/bash
# If you want to rebuild, just do the following:
# sudo docker stop undrupal
# sudo docker rm undrupal
# sudo docker rmi -f emdrupal:latest
#
# If you need to update drupal version then:
#  cd docker-drupal/files
#  rm -rf drupal-7  # incase an old version is there
#  wget http://ftp.drupal.org/files/projects/drupal-7.x-dev.tar.gz
#  tar xf drupal-7.x-dev.tar.gz 
#  mv drupal-7.x-dev drupal-7
#  cd ../..
#
# Finally:
# sudo docker build -t emdrupal:latest docker-drupal

CLIENT=$1
DIR_ROOT=/media/clients/$CLIENT
if [[ $(id -u www-data) ]]; then
	sudo groupadd -g 33 www-data
	sudo useradd -ms /bin/bash www-data -g www-data -u 33
fi
DRUPAL_VERSION=8.1.8
DRUPAL_MD5=7c00b318590a22f2df7a18cf70df06dc
#add more than one site
sudo mkdir -p $DIR_ROOT/drupal/html
sudo chown -R www-data. $DIR_ROOT/drupal
sudo chmod 777 $DIR_ROOT
cd $DIR_ROOT/drupal/html
if [[ ! -d "$DIR_ROOT/drupal" ]]; then
	sudo curl -fSL "http://ftp.drupal.org/files/projects/drupal-${DRUPAL_VERSION}.tar.gz" -o drupal.tar.gz \
        	&& echo "${DRUPAL_MD5} *drupal.tar.gz" | md5sum -c - \
	        && sudo tar -xz --strip-components=1 -f drupal.tar.gz \
	        && sudo rm drupal.tar.gz \
	        && sudo chown -R www-data:www-data sites
fi
OPTIONS="-d -ti -p 127.0.0.1:8003:80 -v $DIR_ROOT/drupal/html:/var/www/html -v $DIR_ROOT/drupal/data:/data -e DRUPAL_DEBUG=1 -e VIRTUAL_HOST=mediadb09.entermediadb.net -e MYSQL_HOST=172.17.0.2 -e MYSQL_DATABASE=mysql -e MYSQL_USER=drupal -e MYSQL_PASSWORD=mypass"
# If you want to run start.sh yourself just append /bin/bash to below line
sudo docker run --name undrupal $OPTIONS emdrupal