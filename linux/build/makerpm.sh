#!/bin/bash -x
cd "$(dirname "$0")"
RELEASE=$1
PLATFORM=$2
BRANCH=$3
INPUT=../$PLATFORM
VERSION=$(cat ../../VERSION${BRANCH}.md)
DEPLOY=../../deploy
REPO=~/workspace/drive/emdev/repo
rm -rf $DEPLOY
mkdir -p $DEPLOY/SPECS

sed "s/{{RELEASE}}/${RELEASE}/g;s/{{VERSION}}/${VERSION}/g;" $INPUT/Entermedia${BRANCH}.spec.template >$DEPLOY/SPECS/Entermedia.spec
./maketar.sh $RELEASE $PLATFORM $BRANCH

./makesrc.sh Entermedia.spec
cd ../../deploy
rpmbuild --rebuild SRPMS/entermediadb*  || { echo "rpmbuild failed"; exit 1; }

cp ./RPMS/x86_64/*.rpm $REPO/$PLATFORM/6/x86_64/rpms
cp ./RPMS/x86_64/*.rpm $REPO/$PLATFORM/7/x86_64/rpms

#yum install createrepo
createrepo --update  $REPO/$PLATFORM/6/x86_64/rpms
createrepo --update  $REPO/$PLATFORM/7/x86_64/rpms

~/workspace/insync-portable/insync-portable force_sync $REPO/$PLATFORM

