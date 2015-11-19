#!/bin/bash
cd "$(dirname "$0")"
set -x 
VERSION=`cat ../../VERSION.md`
RELEASE=$1
PLATFORM=$2
BRANCH=$3
INPUT=../$PLATFORM
DEPLOY=../../deploy
rm -rf $DEPLOY
mkdir -p $DEPLOY/SPECS

sed "s/{{RELEASE}}/${RELEASE}/g;s/{{VERSION}}/${VERSION}/g;" $INPUT/Entermedia${BRANCH}.spec.template >$DEPLOY/SPECS/Entermedia.spec
./maketar.sh $RELEASE $PLATFORM $BRANCH

./makesrc.sh Entermedia.spec
cd ../../deploy
rpmbuild --rebuild SRPMS/entermediadb*  || { echo "rpmbuild failed"; exit 1; }

