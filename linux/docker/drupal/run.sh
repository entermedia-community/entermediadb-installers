#!/bin/bash
# If you want to rebuild, just do the following:
# sudo docker stop unitednations_entermedia
# sudo docker rm unitednations_entermedia
# sudo docker rmi -f boran/drupal:latest
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
# sudo docker build -t boran/drupal:latest docker-drupal

CLIENT=testclient
DIR_ROOT=/opt/entermediadb/clients/$CLIENT
sudo groupadd -g 33 www-data
sudo useradd -ms /bin/bash www-data -g www-data -u 33

#add more than one site
sudo mkdir -p $DIR_ROOT/drupal/html
sudo chown -R www-data. $DIR_ROOT
sudo chmod 777 $DIR_ROOT
OPTIONS="-d -t -p 8003:80 -v $DIR_ROOT/drupal/html:/var/www/html -v $DIR_ROOT/drupal/data:/data -e DRUPAL_DEBUG=1 -e VIRTUAL_HOST=mediadb09.entermediadb.net -e MYSQL_HOST=172.17.0.2 -e MYSQL_DATABASE=mysql -e MYSQL_USER=drupal -e MYSQL_PASSWORD=mypass"
# If you want to run start.sh yourself just append /bin/bash to below line
sudo docker run $OPTIONS $CLIENT_drupal boran/drupal
#sudo docker run -d -t -p 8003:80 -v $DIR_ROOT/drupal/html:/var/www/html -v $DIR_ROOT/drupal/data:/data -e 'VIRTUAL_HOST=mediadb09.entermediadb.net' -e 'MYSQL_HOST=172.17.0.2' -e MYSQL_DATABASE=$CLIENT_drupal -e MYSQL_USER=mysql@% -e 'MYSQL_PASSWORD=mypass' --name $CLIENT_drupal boran/drupal
