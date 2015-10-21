#!/bin/bash
CWD=$(pwd)
source ../functions.sh

if [ ! -f "~/.rpmmacros" ]; then
	echoWhite -n "rpmmacros not found, creating... "
	echo "%_topdir ${TOPLEVEL}" > ~/.rpmmacros
	echo "%debug_package %{nil}" >> ~/.rpmmacros
fi


yum install -y  rpmdevtools yasm wget cmake gcc gcc-c++

wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
sudo rpm -Uvh epel-release-6*.rpm

wget http://packages.sw.be/rpmforge-release/rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm
sudo rpm -Uvh rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm

sudo yum install -y 

mkdir -p "${TOPLEVEL}/SOURCES"
#wget http://www.imagemagick.org/download/releases/ImageMagick-6.9.1-9.tar.bz2
wget http://www.imagemagick.org/download/releases/ImageMagick-6.9.2-4.tar.bz2

cp ImageMagick* ${TOPLEVEL}/SOURCES
cp ../specs/ImageMagick.spec ${TOPLEVEL}/SPECS
cp ../specs/*.patch ${TOPLEVEL}/SPECS

rpmbuild -bs -vv ${TOPLEVEL}/SPECS/ImageMagick.spec
sudo yum-builddep -v ${TOPLEVEL}/SRPMS/ImageMagick-6.9.2-4.src.rpm 
rpmbuild --rebuild -vv ${TOPLEVEL}/SRPMS/ImageMagick-6.9.2-4.src.rpm 

