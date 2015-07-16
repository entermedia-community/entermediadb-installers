#!/bin/bash
EMHOME=/opt/entermediadb/common
cd $EMHOME
    echo "Shutting down ${tomcat}"
        ${EMHOME}/8444/tomcat/bin/shutdown.sh
    sleep 10
    echo "Restarting ${tomcat}"
    rm -rf ${EMHOME}/8444/tomcat/logs/*
        ${EMHOME}/8444/tomcat/bin/startup.sh
echo 'Reload complete!';

