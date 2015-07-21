#!/bin/bash
VERSION=`cat ../../VERSION.md`
RELEASE=`cat ../../RELEASE.md`
TMPDEST="../../deploy/tmp/entermedia-${VERSION}-${RELEASE}"

rm -rf ${TMPDEST}
mkdir -p ${TMPDEST}/home/entermedia
cp -rp ../../linux/usr ${TMPDEST}
cp -rp ../../linux/usr/share/entermediadb/conf/ffmpeg ${TMPDEST}/home/entermedia/.ffmpeg
cp -rp ../../linux/redhat/qt-faststart ${TMPDEST}/usr/bin

wget  -N  http://dev.entermediasoftware.com/jenkins/job/demoall/lastSuccessfulBuild/artifact/deploy/ROOT.war -O /tmp/ROOT.WAR

mkdir -p ${TMPDEST}/usr/share/entermediadb/webapp
unzip  /tmp/ROOT.WAR -d ${TMPDEST}/usr/share/entermediadb/webapp > /dev/null
mkdir ../../deploy/SOURCES
cd ../../deploy/tmp
tar -pczf /tmp/entermedia-${VERSION}-${RELEASE}.tar.gz .
mv  /tmp/entermedia-${VERSION}-${RELEASE}.tar.gz ../../deploy/SOURCES/
