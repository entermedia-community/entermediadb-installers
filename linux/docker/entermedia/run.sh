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
	sudo cp -rp ${ENTERMEDIA_SHARE}/conf/ffmpeg ${ENDPOINT}/.ffmpeg
	sudo cp -rp ${ENTERMEDIA_SHARE}/conf/im/delegates.xml ${ENDPOINT}/
	sudo mv ${ENDPOINT}/webapp/WEB-INF/data ${ENDPOINT}/data
fi

if [[ ! -d "${ENDPOINT}/tomcat${PORT}" ]]; then
	sudo cp -rp ${ENTERMEDIA_SHARE}/tomcat ${ENDPOINT}/tomcat${PORT}
	sudo mkdir ${ENDPOINT}/tomcat${PORT}/logs
	sudo sh -c 'sed "s/%PORT%/${PORT}/g;s/%NODE_ID%/${NODE_ID}/g" <"${ENTERMEDIA_SHARE}/tomcat/conf/server.xml.cluster" >"${ENDPOINT}/tomcat${PORT}/conf/server.xml"'
	sudo sh -c 'sed "s|%ENDPOINT%|${ENDPOINT}|g" <"${ENTERMEDIA_SHARE}/tomcat/bin/tomcat.template" >"${ENDPOINT}/tomcat${PORT}/bin/tomcat"'
	echo Updating node.xml cluster name ...
	sudo sh -c 'sed "s|%CLUSTER_NAME%|${CLUSTER_NAME}|g" <"${ENTERMEDIA_SHARE}/conf/node.xml.cluster" >"${ENDPOINT}/webapp/WEB-INF/node.xml"'
fi

sudo chown -R entermedia. ${ENDPOINT}
# Run catalina in image to keep alive
sudo docker run -it -p $PORT:$PORT \
	-v ${ENDPOINT}/webapp:/opt/entermediadb/webapp \
	-v ${ENDPOINT}/data:/opt/entermediadb/webapp/WEB-INF/data \
	-v ${ENDPOINT}/tomcat${PORT}:/opt/entermediadb/tomcat \
	-v ${ENDPOINT}/.ffmpeg:/home/entermedia/ \
	-v ${ENDPOINT}/delegates.xml:/etc/ImageMagick-6/delegates.xml \
	clients:${CLIENT} \
	/usr/bin/entermediadb-deploy /opt/entermediadb
