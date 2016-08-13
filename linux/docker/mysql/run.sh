# might have to update bind_address= or host= in build/my.cnf ?

sudo docker run --name unmysql -p 3306:3306 -d emmysql  /sbin/my_init
echo mysql -u root -h 172.17.0.2 -P 3306 -p
echo mysql --password=supersecret -u root 
echo "CREATE USER 'drupal'";

echo "GRANT ALL PRIVILEGES ON *.* TO 'drupal' WITH GRANT OPTION;"
# Should we be granting privileges for 'drupal'@'%' or 172.17.0.1 or something?

#echo "SET PASSWORD FOR 'drupal'@'localhost' = PASSWORD('mypass');"
echo "SET PASSWORD FOR 'drupal' = PASSWORD('mypass');"

echo sudo docker exec -it mysqldb /bin/bash
echo mysql -p -u mysql -h 172.17.0.2 -P 3306
echo mysql -p -u root -h localhost -P 3306

