#!/bin/bash -x
RELEASE=$1
PLATFORM=$2
BRANCH=$3
INPUT=../$PLATFORM
DEPLOY=../../deploy
#DOWNLOAD=

#VERSION=$(cat ../../VERSION${BRANCH}.md)
VERSION="11.0"

if [[ "$BRANCH" == "_dev" ]] ; then
	DOWNLOAD="dev_demoall"
elif [[ "$BRANCH" == "_em9" ]] ; then
	DOWNLOAD="em9_"demoall
elif [[ "$BRANCH" == "_em9dev" ]] ; then
	DOWNLOAD="em9dev_demoall"
elif [[ "$BRANCH" == "_em10dev" ]] ; then
	DOWNLOAD="em10_release"
elif [[ "$BRANCH" == "_em11" ]] ; then
        DOWNLOAD="em11_demoall"
fi

set -x 
RELEASE_VERSION="${VERSION}"
echo "Building ${VERSION} ..."
TMPDEST="$DEPLOY/tmp/entermediadb${BRANCH}-${VERSION}"

rm -rf ${TMPDEST}
mkdir -p ${TMPDEST}
cp -rp ../../linux/usr ${TMPDEST}
cp -rp ../../linux/$PLATFORM/qt-faststart ${TMPDEST}/usr/bin

#wget  -N  http://dev.entermediadb.org/jenkins/job/${DOWNLOAD}demoall/lastSuccessfulBuild/artifact/deploy/ROOT.war -O /tmp/ROOT.WAR >/dev/null 2>&1
wget  -N  http://dev.entermediadb.org/jenkins/job/${DOWNLOAD}/lastSuccessfulBuild/artifact/deploy/ROOT.war -O /tmp/ROOT.WAR >/dev/null 2>&1

mkdir -p ${TMPDEST}/usr/share/entermediadb/webapp
unzip  /tmp/ROOT.WAR -d ${TMPDEST}/usr/share/entermediadb/webapp > /dev/null
mkdir -p $DEPLOY/SOURCES
cd $DEPLOY/tmp
chmod 755 $DEPLOY/tmp/entermediadb${BRANCH}-${RELEASE_VERSION}/usr/share/entermediadb/webapp/WEB-INF/bin/linux/exiftoolthumb.sh
tar -pczf /tmp/entermediadb${BRANCH}-${RELEASE_VERSION}.tar.gz .
#mv  /tmp/entermediadb${BRANCH}-${VERSION}.tar.gz $DEPLOY/SOURCES/

echo "Publishing tar file"
mv /tmp/entermediadb${BRANCH}-${VERSION}.tar.gz /workspace/drive/emdev/repo/src/


