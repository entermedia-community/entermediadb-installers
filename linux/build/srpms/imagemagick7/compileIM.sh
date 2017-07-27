#!/bin/bash
CWD=$(pwd)
source ../../functions.sh

if [ ! -f "~/.rpmmacros" ]; then
	echoWhite -n "rpmmacros not found, creating... "
	echo "%_topdir ${TOPLEVEL}" > ~/.rpmmacros
	echo "%debug_package %{nil}" >> ~/.rpmmacros
fi


#sudo yum install -y  rpmdevtools yasm wget cmake gcc gcc-c++ yum-utils

#wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
#sudo rpm -Uvh epel-release-6*.rpm

#wget http://packages.sw.be/rpmforge-release/rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm
#sudo rpm -Uvh rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm

#sudo yum install -y 

mkdir -p "${TOPLEVEL}/SOURCES"
#wget http://www.imagemagick.org/download/releases/ImageMagick-6.9.1-9.tar.bz2
#wget http://ftp.sunet.se/pub/multimedia/graphics/ImageMagick/releases/ImageMagick-6.9.1-9.tar.bz2
#wget http://www.imagemagick.org/download/releases/ImageMagick-6.9.2-4.tar.bz2
#wget http://www.imagemagick.org/download/releases/ImageMagick-6.9.3-0.tar.gz

#wget http://www.imagemagick.org/download/releases/ImageMagick-6.9.3-7.tar.gz
wget http://www.imagemagick.org/download/releases/ImageMagick-7.0.6-1.tar.gz


cp ImageMagick-7.0.6-1.tar.gz ${TOPLEVEL}/SOURCES
cp ImageMagick.spec ${TOPLEVEL}/SPECS
cp *.patch ${TOPLEVEL}/SOURCES

rpmbuild -bs -vv ${TOPLEVEL}/SPECS/ImageMagick.spec
sudo yum-builddep -v ${TOPLEVEL}/SRPMS/ImageMagick-7.0.6-1.src.rpm 
rpmbuild --rebuild -vv ${TOPLEVEL}/SRPMS/ImageMagick-7.0.6-1.src.rpm 

