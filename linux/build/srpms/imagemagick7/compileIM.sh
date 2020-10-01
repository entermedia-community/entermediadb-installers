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
#sudo yum install -y libtool-ltdl-devel
mkdir -p "${TOPLEVEL}/SOURCES"

IMGVERSION=7.0.10-31
### Get Latest URL from: https://www.imagemagick.org/download/
wget https://www.imagemagick.org/download/ImageMagick-$IMGVERSION.tar.bz2

cp ImageMagick-$IMGVERSION.tar.bz2 ${TOPLEVEL}/SOURCES
cp ImageMagick.spec ${TOPLEVEL}/SPECS
cp *.patch ${TOPLEVEL}/SOURCES

rpmbuild -bs -vv ${TOPLEVEL}/SPECS/ImageMagick.spec
sudo yum-builddep -v ${TOPLEVEL}/SRPMS/ImageMagick-$IMGVERSION.src.rpm 
rpmbuild --rebuild -vv ${TOPLEVEL}/SRPMS/ImageMagick-$IMGVERSION.src.rpm

