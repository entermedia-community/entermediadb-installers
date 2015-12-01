#!/bin/bash
#yum install dpkg
cd "$(dirname "$0")"
set -x 
VERSION=`cat ../../VERSION.md`
RELEASE=$1
PLATFORM=$2
BRANCH=$3
INPUT=../$PLATFORM
DEPLOY=../../deploy
NAME="entermediadb-${VERSION}-${RELEASE}"
DOWNLOAD=
TMPDEST=$DEPLOY/$NAME
rm -rf $DEPLOY

mkdir -p $DEPLOY/$NAME
cp -rp ../usr $DEPLOY/$NAME
cp -rp ../debian/DEBIAN $DEPLOY/$NAME

#Download war
if [[ "$BRANCH" == "_dev" ]] ; then
	DOWNLOAD="dev_"
fi

cp -rp ../linux/$PLATFORM/qt-faststart ${TMPDEST}/usr/bin

wget  -N  http://dev.entermediasoftware.com/jenkins/job/${DOWNLOAD}demoall/lastSuccessfulBuild/artifa
ct/deploy/ROOT.war -O /tmp/ROOT.WAR >/dev/null 2>&1


mkdir -p ${TMPDEST}/usr/share/entermediadb/webapp
unzip  /tmp/ROOT.WAR -d ${TMPDEST}/usr/share/entermediadb/webapp > /dev/null
chmod 755 ${TMPDEST}/usr/share/entermediadb/webapp/WEB-INF/bin/linux/exiftoolthumb.sh


sed "s/{{RELEASE}}/${RELEASE}/g;s/{{VERSION}}/${VERSION}/g;" $INPUT/DEBIAN/control.template >$DEPLOY/$NAME/DEBIAN/control

dpkg --build ${TMPDEST}

#Upload it to repo

