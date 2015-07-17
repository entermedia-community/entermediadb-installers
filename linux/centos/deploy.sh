#!/bin/bash
./build.sh
cd ../build
./make.sh Entermedia.spec
cd ../../deploy
rpmbuild --rebuild SRPMS/entermedia-*
scp RPMS/entermedia-* emdev@woody.entermediadb.net:/home/emdev/webapp/repo/centos/6/x86_64/rpms
