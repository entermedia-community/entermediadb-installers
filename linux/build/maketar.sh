RELEASE=$1
PLATFORM=$2
BRANCH=$3
INPUT=../$PLATFORM
DEPLOY=../../deploy
DOWNLOAD=

VERSION=$(cat ../../VERSION${BRANCH}.md)

if [[ "$BRANCH" == "_dev" ]] ; then
	DOWNLOAD="dev_"
elif [[ "$BRANCH" == "_em9" ]] ; then
	DOWNLOAD="em9_"
fi

set -x 
RELEASE_VERSION="${VERSION}"
TMPDEST="$DEPLOY/tmp/entermediadb${BRANCH}-${RELEASE_VERSION}"

rm -rf ${TMPDEST}
mkdir -p ${TMPDEST}
cp -rp ../../linux/usr ${TMPDEST}
cp -rp ../../linux/$PLATFORM/qt-faststart ${TMPDEST}/usr/bin

wget  -N  http://dev.entermediasoftware.com/jenkins/job/${DOWNLOAD}demoall/lastSuccessfulBuild/artifact/deploy/ROOT.war -O /tmp/ROOT.WAR >/dev/null 2>&1

mkdir -p ${TMPDEST}/usr/share/entermediadb/webapp
unzip  /tmp/ROOT.WAR -d ${TMPDEST}/usr/share/entermediadb/webapp > /dev/null
mkdir $DEPLOY/SOURCES
cd $DEPLOY/tmp
chmod 755 $DEPLOY/tmp/entermediadb${BRANCH}-${RELEASE_VERSION}/usr/share/entermediadb/webapp/WEB-INF/bin/linux/exiftoolthumb.sh
tar -pczf /tmp/entermediadb${BRANCH}-${RELEASE_VERSION}.tar.gz .
mv  /tmp/entermediadb${BRANCH}-${RELEASE_VERSION}.tar.gz $DEPLOY/SOURCES/
