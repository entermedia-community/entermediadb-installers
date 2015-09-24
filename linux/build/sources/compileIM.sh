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
rpm -Uvh rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm

yum install -y 

mkdir -p "${TOPLEVEL}/SOURCES"
cp ../sources/* ${TOPLEVEL}/SOURCES
wget http://www.imagemagick.org/download/releases/ImageMagick-6.9.1-9.tar.bz2
cd ..
cp ../specs/ImageMagick* ${TOPLEVEL}/SPECS
rpmbuild -bs SPECS/ImageMagick.spec
sudo yum-builddep ImageMagick-6.9.1-9.src.rpm 
rpmbuild --rebuild ImageMagick-6.9.1-9.src.rpm 

