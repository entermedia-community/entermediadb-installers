#!/bin/bash -x
DOMAIN=$1
PASS=qazwsxedc
#https://letsencrypt.org/getting-started/

[[ -f $(which git) ]] || sudo yum install -y git
git clone https://github.com/letsencrypt/letsencrypt

cd letsencrypt
rm private.keystore

# UPDATE webroot path
./letsencrypt-auto certonly   --webroot -w /media/emsites/client/webapp/ -d  ${DOMAIN}

#CDN
#./letsencrypt-auto certonly   --webroot -w /media/emsites/client/webapp/ -d  ${DOMAIN} -d cdn.${DOMAIN}

keytool -import -alias other -keystore private.keystore -storepass ${PASS} -trustcacerts -file /etc/letsencrypt/live/${DOMAIN}/fullchain.pem

openssl pkcs12 -export -in /etc/letsencrypt/live/${DOMAIN}/fullchain.pem -inkey /etc/letsencrypt/live/${DOMAIN}/privkey.pem -out cert_and_key.p12 -name tomcat -CAfile /etc/letsencrypt/live/${DOMAIN}/fullchain.pem -caname root

keytool -importkeystore -deststorepass qazwsxedc -destkeypass qazwsxedc -destkeystore private.keystore -srckeystore cert_and_key.p12 -srcstoretype PKCS12 -srcstorepass ${PASS} -alias tomcat

keytool -import -trustcacerts -alias root -file /etc/letsencrypt/live/${DOMAIN}/fullchain.pem -keystore private.keystore

