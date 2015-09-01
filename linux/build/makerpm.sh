#!/bin/bash
set -x 
VERSION=`cat ../../VERSION.md`
RELEASE=`cat ../../RELEASE.md`
PLATFORM=$1
BRANCH=$2
INPUT=../$PLATFORM
DEPLOY=../../deploy
rm -rf $DEPLOY
mkdir -p $DEPLOY/SPECS

sed "s/{{RELEASE}}/${RELEASE}/g;s/{{VERSION}}/${VERSION}/g;" $INPUT/Entermedia${BRANCH}.spec.template >$DEPLOY/SPECS/Entermedia.spec
./maketar.sh $PLATFORM $BRANCH


./makesrc.sh Entermedia.spec
cd ../../deploy
rpmbuild --rebuild SRPMS/entermediadb*  || { echo "rpmbuild failed"; exit 1; }

