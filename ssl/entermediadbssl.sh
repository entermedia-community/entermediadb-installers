#!/bin/bash -x
DOMAIN=$1
PASS=qazwsxedc
#https://letsencrypt.org/getting-started/

#sudo yum install -y git
#git clone https://github.com/letsencrypt/letsencrypt

cd letsencrypt

## This script needs to be run on the actual server.
rm private.keystore

./letsencrypt-auto certonly   --webroot -w /opt/entermediadb/webapp/ -d  ${DOMAIN} -d cdn.${DOMAIN}

keytool -import -alias other -keystore private.keystore -storepass ${PASS} -trustcacerts -file /etc/letsencrypt/live/${DOMAIN}/fullchain.pem

openssl pkcs12 -export -in /etc/letsencrypt/live/${DOMAIN}/fullchain.pem -inkey /etc/letsencrypt/live/${DOMAIN}/privkey.pem -out cert_and_key.p12 -name tomcat -C
Afile /etc/letsencrypt/live/${DOMAIN}/fullcha
in.pem -caname root

keytool -importkeystore -deststorepass qazwsxedc -destkeypass qazwsxedc -destkeystore private.keystore -srckeystore cert_and_key.p12 -srcstoretype PKCS12 -srcsto
repass ${PASS} -alias tomcat

keytool -import -trustcacerts -alias root -file /etc/letsencrypt/live/${DOMAIN}/fullchain.pem -keystore private.keystore

