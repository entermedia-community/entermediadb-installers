##make sure you have a user useradd entermedia 

HERE=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
REPO_ROOT=$( cd ../.. && pwd )

adduser entermedia
usermod -a -G vboxsf entermedia

# Fix File Limits
echo "fs.file-max = 10000000" >> /etc/sysctl.conf
echo "entermedia      soft    nofile  409600" >> /etc/security/limits.conf
echo "entermedia      hard    nofile  1024000" >> /etc/security/limits.conf
sysctl -p
#End Fix File Limits
cp -rp ${REPO_ROOT}/linux/common/ffmpeg /home/entermedia/.ffmpeg

chown -R entermedia:entermedia /home/entermedia/.ffmpeg

cp tomcat /etc/init.d/
chkconfig --add tomcat
chkconfig --level 3 tomcat on
chkconfig --level 5 tomcat on

#Remove any old tomcat if it exists
rm -r /opt/entermedia/tomcat

mkdir -p /opt/entermedia/tomcat/logs
mkdir -p /opt/entermedia/webapp
cp -rp ../entermedia/* /opt/entermedia/
cp -p ../misc/delegates.xml /etc/ImageMagick/delegates.xml

cd /opt/entermedia/webapp
wget http://dev.entermediasoftware.com/jenkins/view/Demo/job/demoall/lastSuccessfulBuild/artifact/deploy/ROOT.war -O ROOT.war
unzip ROOT.war 
rm ROOT.war

#Copy data directory out and link it
mkdir /media
mv /opt/entermedia/webapp/WEB-INF/data /media
ln -s /media/data /opt/entermedia/webapp/WEB-INF/data

chown -R entermedia:entermedia /opt/entermedia

chmod -R u+s,g+s /opt/entermedia 

cp 
#iptables -F
export ip=`ifconfig eth0 |grep "inet addr" |awk '{print $2}' |awk -F: '{print $2}'`
/sbin/iptables -t nat -A OUTPUT -d localhost -p tcp --dport 80 -j REDIRECT --to-ports 8080
/sbin/iptables -t nat -A OUTPUT -d $ip -p tcp --dport 80 -j REDIRECT --to-ports 8080
/sbin/iptables -t nat -A PREROUTING -d $ip -p tcp --dport 80 -j REDIRECT --to-ports 8080

/sbin/iptables -t nat -A OUTPUT -d localhost -p tcp --dport 22 -j REDIRECT --to-ports 22
/sbin/iptables -t nat -A OUTPUT -d $ip -p tcp --dport 22 -j REDIRECT --to-ports 22
/sbin/iptables -t nat -A PREROUTING -d $ip -p tcp --dport 22 -j REDIRECT --to-ports 22


iptables-save > /etc/sysconfig/iptables

