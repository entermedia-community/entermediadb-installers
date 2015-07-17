RELEASE_VERSION=`cat ../../VERSION.md`
TMPDEST="../../deploy/tmp/entermedia-${RELEASE_VERSION}"

rm -rf ${TMPDEST}
mkdir -p ${TMPDEST}/{usr/{share,bin},home}/entermedia/.ffmpeg
cp -rp ../../linux/usr/share/entermediadb/conf/ffmpeg/libx264-normal.ffpreset ${TMPDEST}/home/entermedia/.ffmpeg
cp -rp ../../linux/tomcat ${TMPDEST}/usr/share/entermedia
cp -rp ../../linux/usr/bin ${TMPDEST}/usr
cp -rp ../../linux/centos/qt-faststart ${TMPDEST}/usr/bin

wget  -N -nd  http://dev.entermediasoftware.com/jenkins/job/demoall/lastSuccessfulBuild/artifact/deploy/ROOT.war -O /tmp/ROOT.WAR

mkdir -p ${TMPDEST}/usr/share/entermedia/webapp
unzip  /tmp/ROOT.WAR -d ${TMPDEST}/usr/share/entermedia/webapp > /dev/null
mkdir ../../deploy/SOURCES
cd ../../deploy/tmp
tar -pczf /tmp/entermedia-${RELEASE_VERSION}.tar.gz .
mv  /tmp/entermedia-${RELEASE_VERSION}.tar.gz ../../deploy/SOURCES/
