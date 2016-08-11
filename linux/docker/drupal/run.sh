#!/bin/bash
CLIENT=testclient
DIR_ROOT=/opt/entermediadb/clients/$CLIENT
sudo groupadd -g 33 www-data
sudo useradd -ms /bin/bash www-data -g www-data -u 33

#add more than one site
sudo mkdir -p $DIR_ROOT/drupal/html
sudo chown -R www-data. $DIR_ROOT
sudo chmod 777 $DIR_ROOT
OPTIONS="-d -t -p 8003:80 -v $DIR_ROOT/drupal/html:/var/www/html -v $DIR_ROOT/drupal/data:/data -e 'VIRTUAL_HOST=mediadb09.entermediadb.net' -e 'MYSQL_HOST=172.17.0.2' -e MYSQL_DATABASE=$CLIENT_drupal -e MYSQL_USER=mysql@% -e 'MYSQL_PASSWORD=mypass'"
sudo docker run $OPTIONS $CLIENT_drupal boran/drupal
#sudo docker run -d -t -p 8003:80 -v $DIR_ROOT/drupal/html:/var/www/html -v $DIR_ROOT/drupal/data:/data -e 'VIRTUAL_HOST=mediadb09.entermediadb.net' -e 'MYSQL_HOST=172.17.0.2' -e MYSQL_DATABASE=$CLIENT_drupal -e MYSQL_USER=mysql@% -e 'MYSQL_PASSWORD=mypass' --name $CLIENT_drupal boran/drupal
