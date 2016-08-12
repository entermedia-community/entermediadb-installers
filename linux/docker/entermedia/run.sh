#!/bin/bash -x
PORT=8899
CLIENT=unitednations

NODE_ID=test2${PORT}
CLUSTER_NAME=${CLIENT}

ENTERMEDIA_SHARE=/usr/share/entermediadb
ENDPOINT=/opt/entermediadb/clients/${CLIENT}


# Make client mount area

if [[ ! -d "${ENDPOINT}/webapp" ]]; then
	mkdir -p ${ENDPOINT}
	#Copy webapp, data and tomcat
	cp -rp ${ENTERMEDIA_SHARE}/webapp ${ENDPOINT}/
	cp -rp ${ENTERMEDIA_SHARE}/conf/ffmpeg ${ENDPOINT}/.ffmpeg
	cp -rp ${ENTERMEDIA_SHARE}/conf/im/delegates.xml ${ENDPOINT}/
	mv ${ENDPOINT}/webapp/WEB-INF/data ${ENDPOINT}/data
fi

if [[ ! -d "${ENDPOINT}/tomcat${PORT}" ]]; then
	cp -rp ${ENTERMEDIA_SHARE}/tomcat ${ENDPOINT}/tomcat${PORT}
	mkdir ${ENDPOINT}/tomcat${PORT}/logs
	sed "s/%PORT%/${PORT}/g;s/%NODE_ID%/${NODE_ID}/g" <"${ENTERMEDIA_SHARE}/tomcat/conf/server.xml.cluster" >"${ENDPOINT}/tomcat${PORT}/conf/server.xml"
	sed "s|%ENDPOINT|${ENDPOINT}|g" <"${ENTERMEDIA_SHARE}/tomcat/bin/tomcat.template" >"${ENDPOINT}/tomcat${PORT}/bin/tomcat"
	echo Updating node.xml cluster name ...
	sed "s/%CLUSTER_NAME%/${CLUSTER_NAME}/g" <"${ENTERMEDIA_SHARE}/conf/node.xml.cluster" >"${ENDPOINT}/webapp/WEB-INF/node.xml"
fi

chown -R entermedia. "${ENDPOINT}"

# Fix networking
# echo 'DOCKER_OPTS="--dns 8.8.4.4"' > /etc/default/docker
# Build image for client
docker build -t "clients:${CLIENT}" ./entermedia-docker

# Run catalina in image to keep alive
docker run --name ${CLIENT}_entermedia -p $PORT:$PORT \
	-v ${ENDPOINT}/webapp:/opt/entermediadb/webapp \
	-v ${ENDPOINT}/data:/opt/entermediadb/webapp/WEB-INF/data \
	-v ${ENDPOINT}/tomcat${PORT}:/opt/entermediadb/tomcat \
	-v ${ENDPOINT}/.ffmpeg:/home/entermedia/ \
	-v ${ENDPOINT}/delegates.xml:/etc/ImageMagick-6/delegates.xml \
	clients:${CLIENT}
#	/usr/bin/entermediadb-deploy /opt/entermediadb
