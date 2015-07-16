#!/bin/bash
##make sure you have a user useradd entermedia
HERE=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
REPO_ROOT=$( cd ../.. && pwd )
useradd -m entermedia

# Fix File Limits
echo "fs.file-max = 10000000" >> /etc/sysctl.conf
echo "entermedia      soft    nofile  409600" >> /etc/security/limits.conf
echo "entermedia      hard    nofile  1024000" >> /etc/security/limits.conf
sysctl -p
#End Fix File Limits

cp -rp ${REPO_ROOT}/linux/common/ffmpeg /home/entermedia/.ffmpeg

chown -R entermedia:entermedia /home/entermedia/.ffmpeg

cp ${REPO_ROOT}/linux/common/tomcat /etc/init.d/
update-rc.d tomcat defaults
update-rc.d tomcat start 20 3 5

#Remove any old tomcat if it exists
#rm -rf /opt/entermedia/tomcat
# This is an installation, not upgrade

mkdir -p /opt/entermedia/tomcat/logs
mkdir -p /opt/entermedia/webapp
cp -rp ${REPO_ROOT}/linux/tomcat /opt/entermedia/
cp -p ${REPO_ROOT}/linux/common/imagemagick/delegates.xml /etc/ImageMagick/
cd /opt/entermedia/webapp

#Copy webapp from repository instead of ROOT.war
cp -rp ${REPO_ROOT}/java/webapp/* .

#Copy data directory out and link it
mkdir /media
mv /opt/entermedia/webapp/WEB-INF/data /media/
ln -s /media/data /opt/entermedia/webapp/WEB-INF/data

chown -R entermedia. /opt/entermedia
chown -R entermedia. /media

chmod -R u+s,g+s /opt/entermedia

#iptables -F
export ip=`ifconfig eth0 |grep "inet addr" |awk '{print $2}' |awk -F: '{print $2}'`
ifconfig eth0 |grep "inet addr" |awk '{print $2}' |awk -F: '{print $2}'
/sbin/iptables -t nat -A OUTPUT -d localhost -p tcp --dport 80 -j REDIRECT --to-ports 8080
/sbin/iptables -t nat -A OUTPUT -d $ip -p tcp --dport 80 -j REDIRECT --to-ports 8080
/sbin/iptables -t nat -A PREROUTING -d $ip -p tcp --dport 80 -j REDIRECT --to-ports 8080

/sbin/iptables -t nat -A OUTPUT -d localhost -p tcp --dport 22 -j REDIRECT --to-ports 22
/sbin/iptables -t nat -A OUTPUT -d $ip -p tcp --dport 22 -j REDIRECT --to-ports 22
/sbin/iptables -t nat -A PREROUTING -d $ip -p tcp --dport 22 -j REDIRECT --to-ports 22


iptables-save > /etc/iptables/rules.v4

