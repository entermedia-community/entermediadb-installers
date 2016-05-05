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

#mkdir -p "${TOPLEVEL}/SOURCES"
#cp ../sources/* ${TOPLEVEL}/SOURCES
#wget ftp://rpmfind.net/linux/fedora-secondary/updates/19/source/SRPMS/g/ghostscript-9.07-10.fc19.src.rpm

cp ghostscript-9.18.tar.gz  ${TOPLEVEL}/SOURCES
cp cidfmap ${TOPLEVEL}/SOURCES
cp CIDFnmap ${TOPLEVEL}/SOURCES
cp ../../specs/ghostscript.spec ${TOPLEVEL}/SPECS

rpmbuild -bs -vv ${TOPLEVEL}/SPECS/ghostscript.spec
sudo yum-builddep ${TOPLEVEL}/SRPMS/ghostscript-9.18-7.el7.centos.src.rpm 
rpmbuild --rebuild ${TOPLEVEL}/SRPMS/ghostscript-9.18-7.el7.centos.src.rpm
