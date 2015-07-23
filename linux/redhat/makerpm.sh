#!/bin/bash
VERSION=`cat ../../VERSION.md`
RELEASE=`cat ../../RELEASE.md`
rm -rf ../../deploy
./maketar.sh
cd ../build
rm specs/Entermedia.spec
sed "s/{{RELEASE}}/${RELEASE}/g;s/{{VERSION}}/${VERSION}/g;" specs/Entermedia.spec.template >specs/Entermedia.spec
./build.sh Entermedia.spec
cd ../../deploy
rpmbuild --rebuild SRPMS/entermediadb-*
scp ./RPMS/x86_64/*.rpm emdev@woody.entermediadb.net:/home/emdev/webapp/repo/redhat/7/rpms
ssh emdev@woody.entermediadb.net '/home/emdev/webapp/repo/makeall.sh'

