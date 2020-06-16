#!/bin/bash
CWD=$(pwd)
source ../../functions.sh

if [ ! -f "~/.rpmmacros" ]; then
        echoWhite -n "rpmmacros not found, creating... "
        echo "%_topdir ${TOPLEVEL}" > ~/.rpmmacros
        echo "%debug_package %{nil}" >> ~/.rpmmacros
fi


mkdir /tmp/nginx
cd /tmp/nginx

git clone https://github.com/jhoblitt/nginx-rpmbuild.git

sudo yum install -y perl-devel perl-ExtUtils-Embed GeoIP-devel libxslt-devel gd-devel

mkdir -p "${TOPLEVEL}/SOURCES"
cp -rp /tmp/nginx/nginx-rpmbuild/SOURCES/* "${TOPLEVEL}/SOURCES"

cp -rp /tmp/nginx/nginx-rpmbuild/SPECS/* "${TOPLEVEL}/SPECS"

#rpmbuild -ba rpmbuild/SPECS/nginx.spec 

#rpmbuild -bs -vv ${TOPLEVEL}/SPECS/nginx.spec
sudo yum-builddep -v ${TOPLEVEL}/SRPMS/nginx-1.10.0-1.el7.centos.ngx.src.rpm
rpmbuild --rebuild -vv ${TOPLEVEL}/SRPMS/nginx-1.10.0-1.el7.centos.ngx.src.rpm
