#!/bin/bash
## This script refreshes the spec file with the correct version and release information
VERSIONS=($(cat "VERSION.md"))
ENTERMEDIA_VERSION=${VERSIONS[0]}
ENTERMEDIA_RELEASE=${VERSIONS[1]}
sed -e "s/{{ENTERMEDIA_VERSION}}/$ENTERMEDIA_VERSION/g; s/{{ENTERMEDA_RELEASE}}/$ENTERMEDIA_RELEASE/g" linux/build/specs/Entermedia.spec.template > linux/build/specs/Entermedia.spec
echo Updated linux/build/specs/Entermedia.spec from VERSION.md
