#!/bin/bash
VERSION=`cat ../../VERSION.md`
RELEASE=`cat ../../RELEASE.md`
rm -rf ../../deploy
./maketar.sh
cd ../build
sed -e "s/{{VERSION}}/$VERSION/g; s/{{RELEASE}}/$RELEASE/g" ./Entermedia.spec.template > ./Entermedia.spec
./build.sh Entermedia.spec
cd ../../deploy
rpmbuild --rebuild SRPMS/entermedia-*
scp ./RPMS/7/*.rpm emdev@woody.entermediadb.net:/home/emdev/webapp/repo/redhat/7/rpms
scp ./SRPMS/*.src.rpm emdev@woody.entermediadb.net:/home/emdev/webapp/repo/redhat/7/srpms
