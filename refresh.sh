#!/bin/bash
## This script refreshes the spec file with the correct version and release information
VERSIONS=($(cat "VERSION.md"))
ENTERMEDIA_VERSION=${VERSIONS[0]}
ENTERMEDIA_RELEASE=${VERSIONS[1]}
sed -e "s/{{ENTERMEDIA_VERSION}}/$ENTERMEDIA_VERSION/g; s/{{ENTERMEDA_RELEASE}}/$ENTERMEDIA_RELEASE/g" repo/SPECS/Entermedia.spec.template > repo/SPECS/Entermedia.spec
echo Updated repo/SPECS/Entermedia.spec from VERSION.md
