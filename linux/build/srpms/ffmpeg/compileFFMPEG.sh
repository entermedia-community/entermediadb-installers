#!/bin/bash
CWD=$(pwd)
SPECSFILE=ffmpeg.spec
source ../../functions.sh

if [ ! -f "~/.rpmmacros" ]; then
	echoWhite -n "rpmmacros not found, creating... "
	echo "%_topdir ${TOPLEVEL}" > ~/.rpmmacros
	echo "%debug_package %{nil}" >> ~/.rpmmacros
fi


sudo yum install -y rpmdevtools yasm wget cmake gcc gcc-c++ yum-utils x264-devel openjpeg-devel

mkdir -p "${TOPLEVEL}/SOURCES"

#wget https://www.ffmpeg.org/releases/ffmpeg-3.4.tar.xz

cp ffmpeg-3.4.tar.xz ${TOPLEVEL}/SOURCES
cp ${SPECSFILE} ${TOPLEVEL}/SPECS

rpmbuild -bs -vv ${TOPLEVEL}/SPECS/${SPECSFILE}
sudo yum-builddep -v ${TOPLEVEL}/SRPMS/ffmpeg-3.4-1.el7.centos.src.rpm 
rpmbuild --rebuild -vv ${TOPLEVEL}/SRPMS/ffmpeg-3.4-1.el7.centos.src.rpm

