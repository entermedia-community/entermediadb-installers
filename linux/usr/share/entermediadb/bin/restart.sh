#!/bin/bash
PORT=$1
EMHOME=/opt/entermediadb/common
cd $EMHOME
    echo "Shutting down ${tomcat}"
        ${EMHOME}/${PORT}/tomcat/bin/shutdown.sh
    sleep 10
    echo "Restarting ${tomcat}"
    rm -rf ${EMHOME}/${PORT}/tomcat/logs/*
        ${EMHOME}/${PORT}/tomcat/bin/startup.sh
echo 'Reload complete!';

