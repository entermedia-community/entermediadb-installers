#!/bin/bash
rm -rf ../../deploy
./maketar.sh
cd ../build
./build.sh Entermedia.spec
cd ../../deploy
rpmbuild --rebuild SRPMS/entermedia-*
scp ./RPMS/x86_64/*.rpm emdev@woody.entermediadb.net:/home/emdev/webapp/repo/centos/6/x86_64/rpms
