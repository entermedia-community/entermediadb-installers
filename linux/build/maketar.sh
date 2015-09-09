PLATFORM=$1
BRANCH=$2
INPUT=../$PLATFORM
DEPLOY=../../deploy
DOWNLOAD=

VERSION=`cat ../../VERSION.md`
RELEASE=`cat ../../RELEASE.md`

if [[ "$BRANCH" == "_dev" ]] ; then
	DOWNLOAD="dev_"
fi

set -x 
RELEASE_VERSION="${VERSION}"
TMPDEST="$DEPLOY/tmp/entermediadb${BRANCH}-${RELEASE_VERSION}"

rm -rf ${TMPDEST}
mkdir -p ${TMPDEST}/home/entermedia
cp -rp ../../linux/usr ${TMPDEST}
cp -rp ../../linux/usr/share/entermediadb/conf/ffmpeg ${TMPDEST}/home/entermedia/.ffmpeg
cp -rp ../../linux/$PLATFORM/qt-faststart ${TMPDEST}/usr/bin

wget  -N  http://dev.entermediasoftware.com/jenkins/job/${DOWNLOAD}demoall/lastSuccessfulBuild/artifact/deploy/ROOT.war -O /tmp/ROOT.WAR

mkdir -p ${TMPDEST}/usr/share/entermediadb/webapp
unzip  /tmp/ROOT.WAR -d ${TMPDEST}/usr/share/entermediadb/webapp > /dev/null
mkdir $DEPLOY/SOURCES
cd $DEPLOY/tmp
tar -pczf /tmp/entermediadb${BRANCH}-${RELEASE_VERSION}.tar.gz .
mv  /tmp/entermediadb${BRANCH}-${RELEASE_VERSION}.tar.gz $DEPLOY/SOURCES/
