#!/bin/bash -x
PORT=8081
CLIENT=unitednations

NODE_ID=test2${PORT}
CLUSTER_NAME=${CLIENT}

ENTERMEDIA_SHARE=/usr/share/entermediadb
ENDPOINT=/opt/entermediadb/clients/${CLIENT}

# Fix networking
# echo 'DOCKER_OPTS="--dns 8.8.4.4"' > /etc/default/docker
# Build image for client
sudo docker build -t "clients:${CLIENT}" ./entermedia-docker

# Make client mount area

if [[ ! -d "${ENDPOINT}/webapp" ]]; then
	sudo mkdir -p ${ENDPOINT}
	#Copy webapp, data and tomcat
	sudo cp -rp ${ENTERMEDIA_SHARE}/webapp ${ENDPOINT}/
	sudo mv ${ENDPOINT}/webapp/WEB-INF/data ${ENDPOINT}/data
	sudo chown -R entermedia. ${ENDPOINT}
fi

if [[ ! -d "${ENDPOINT}/tomcat${PORT}" ]]; then
	sudo cp -rp ${ENTERMEDIA_SHARE}/tomcat ${ENDPOINT}/tomcat${PORT}
	sudo mkdir ${ENDPOINT}/tomcat${PORT}/logs
	sudo chown -R entermedia. ${ENDPOINT}
	sed "s/%PORT%/${PORT}/g;s/%NODE_ID%/${NODE_ID}/g" <"${ENTERMEDIA_SHARE}/tomcat/conf/server.xml.cluster" >"${ENDPOINT}/tomcat${PORT}/conf/server.xml"
	sed "s|%ENDPOINT%|${ENDPOINT}|g" <"${ENTERMEDIA_SHARE}/tomcat/bin/tomcat.template" >"${ENDPOINT}/tomcat${PORT}/bin/tomcat"
	echo Updating node.xml cluster name ...
	sed "s|%CLUSTER_NAME%|${CLUSTER_NAME}|g" <"${ENTERMEDIA_SHARE}/conf/node.xml.cluster" >"${ENDPOINT}/webapp/WEB-INF/node.xml"
fi

# Run catalina in image to keep alive
sudo docker run  -p $PORT:$PORT \
	-v ${ENDPOINT}/webapp:/opt/entermediadb/webapp \
	-v ${ENDPOINT}/data:/opt/entermediadb/webapp/WEB-INF/data \
	-v ${ENDPOINT}/tomcat${PORT}:/opt/entermediadb/tomcat \
	-u entermedia \
	-it clients:${CLIENT} \
	/usr/bin/entermediadb-deploy /opt/entermediadb