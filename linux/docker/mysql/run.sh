sudo docker run --name unmysql -p 3306:3306 -d emmysql  /sbin/my_init
echo mysql -u root -h 172.17.0.3 -P 3306 -p
echo mysql --password=supersecret -u root 
echo "CREATE USER 'mysql'";
echo "GRANT ALL PRIVILEGES ON *.* TO 'mysql' IDENTIFIED BY 'mysql' WITH GRANT OPTION;"
#echo "SET PASSWORD FOR 'mysql'@'localhost' = PASSWORD('mypass');"
echo "SET PASSWORD FOR 'mysql' = PASSWORD('mypass');"

echo sudo docker exec -it mysqldb /bin/bash
echo mysql -p -u mysql -h 172.17.0.2 -P 3306
echo mysql -p -u root -h localhost -P 3306

