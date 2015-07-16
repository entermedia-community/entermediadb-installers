RELEASE_VERSION=`cat ../../VERSION.md`
mkdir -p entermedia-${RELEASE_VERSION}/{usr/{share,bin},home}/entermedia
cp -rp ../../linux/common/ffmpeg/libx264-normal.ffpreset entermedia-${RELEASE_VERSION}/home/entermedia/.ffmpeg
cp -rp ../../linux/tomcat entermedia-${RELEASE_VERSION}/usr/share/entermedia
cp -rp ../../linux/centos/qt-faststart entermedia-${RELEASE_VERSION}/usr/bin
cp -rp ../../java/webapp entermedia-${RELEASE_VERSION}/usr/share/entermedia
tar -pczf ../../repo/SOURCES/entermedia-${RELEASE_VERSION}.tar.gz ./entermedia-${RELEASE_VERSION}
rm -rf entermedia-${RELEASE_VERSION}

