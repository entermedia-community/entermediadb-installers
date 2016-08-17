# might have to update bind_address= or host= in build/my.cnf ?


CLIENT=unitednations
DIR_ROOT=/media/clients/$CLIENT
sudo groupadd -g 105 mysql
sudo useradd -ms /bin/bash mysql -g mysql -u 103

sudo mkdir -p $DIR_ROOT/mysql
sudo chown -R mysql. $DIR_ROOT/mysql

sudo docker stop unmysql
sudo docker rm unmysql


sudo docker run --name unmysql -v $DIR_ROOT/mysql:/var/lib/mysql -p 3306:3306 -d emmysql  /sbin/my_init
echo mysql -u root -h 172.17.0.2 -P 3306 -p
echo mysql --password=supersecret -u root 
echo "CREATE USER 'drupal';"

echo "GRANT ALL PRIVILEGES ON *.* TO 'drupal'@'%' WITH GRANT OPTION;"
# Should we be granting privileges for 'drupal'@'%' or 172.17.0.1 or something?

echo "SET PASSWORD FOR 'drupal' = PASSWORD('mypass');"

echo sudo docker exec -it unmysql /bin/bash
echo mysql -p -u mysql -h 172.17.0.2 -P 3306
echo mysql -p -u root -h localhost -P 3306

