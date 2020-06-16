#!/bin/bash -x
CWD=$(pwd)
source ../../functions.sh

if [ ! -f "~/.rpmmacros" ]; then
       echoWhite -n "rpmmacros not found, creating... "
       echo "%_topdir ${TOPLEVEL}" > ~/.rpmmacros
       echo "%debug_package %{nil}" >> ~/.rpmmacros
fi

sudo yum install -y perl-devel perl-ExtUtils-Embed GeoIP-devel libxslt-devel gd-devel buildreq-cpan  openssl-devel pcre-devel zlib-devel

#sudo wget http://nginx.org/download/nginx-1.14.2.tar.gz -P /tmp/

mkdir -p "${TOPLEVEL}/SOURCES"
cp -rp /tmp/nginx-1.14.2.tar.gz "${TOPLEVEL}/SOURCES"

cp -rp ../../specs/nginx.spec "${TOPLEVEL}/SPECS"

rpmbuild -bs -vv ${TOPLEVEL}/SPECS/nginx.spec

#sudo yum-builddep -v ${TOPLEVEL}/SRPMS/nginx-1.14.2-71.src.rpm
#rpmbuild --rebuild -vv ${TOPLEVEL}/SRPMS/nginx-1.14.2-71.src.rpm
