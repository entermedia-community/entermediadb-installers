#!/bin/bash
# If you want to rebuild, just do the following:
# sudo docker build -t emdrupal:php5 docker-drupal

CLIENT=$1
PORT=8004
DIR_ROOT=/media/clients/$CLIENT
DRUPAL_ROOT=$DIR_ROOT/drupal7
CNAME=undrupal7
if [[ $(id -u www-data) ]]; then
	sudo groupadd -g 33 www-data
	sudo useradd -ms /bin/bash www-data -g www-data -u 33
fi
DRUPAL_VERSION=7.50
DRUPAL_MD5=f23905b0248d76f0fc8316692cd64753
#add more than one site
if [[ ! -d "$DRUPAL_ROOT" ]]; then
	sudo mkdir -p $DRUPAL_ROOT/html
	sudo chown -R www-data. $DRUPAL_ROOT
	sudo chmod 755 $DRUPAL_ROOT
	cd $DRUPAL_ROOT/html
	sudo curl -fSL "http://ftp.drupal.org/files/projects/drupal-${DRUPAL_VERSION}.tar.gz" -o drupal.tar.gz \
        	&& echo "${DRUPAL_MD5} *drupal.tar.gz" | md5sum -c - \
	        && sudo tar -xz --strip-components=1 -f drupal.tar.gz \
	        && sudo rm drupal.tar.gz \
	        && sudo chown -R www-data:www-data .
fi
OPTIONS="-d -ti -p 127.0.0.1:${PORT}:80 -v $DRUPAL_ROOT/html:/var/www/html -v $DRUPAL_ROOT/data:/data"
# If you want to run start.sh yourself just append /bin/bash to below line
sudo docker run --name $CNAME $OPTIONS emdrupal:drush
