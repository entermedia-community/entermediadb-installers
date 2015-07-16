#!/bin/bash
cd /tmp
mkdir upgrade
cd upgrade
/usr/bin/wget -r -N -nd  http://dev.entermediasoftware.com/jenkins/job/dev_demoall/lastSuccessfulBuild/artifact/deploy/ROOT.war
/usr/bin/unzip -uo /tmp/upgrade/ROOT.war >/dev/null
rm -rf /opt/entermediadb/webapp/WEB-INF/base
rm -rf /opt/entermediadb/webapp/WEB-INF/lib
cp -rp WEB-INF/base /opt/entermediadb/webapp/WEB-INF/
cp -rp WEB-INF/lib /opt/entermediadb/webapp/WEB-INF/
echo 'Cleaning up demoall copy'
rm -rf /tmp/upgrade
