#!/bin/bash

WEBAPP=/opt/entermediadb/webapp
BIN_DIR=/opt/entermediadb/common/bin
SUB_DOMAIN=$1
CLIENT_ID=$2
CLIENT_NAME=$3

${BIN_DIR}/configureclientelastic.sh "$SUB_DOMAIN" "$CLIENT_ID" "$CLIENT_NAME"

CATALOG="$WEBAPP/$CLIENT_ID"
# Validate request
if [ ! -d $CATALOG ]; then
    echo '$CLIENT_ID is not an existing client'
    exit 1
fi

${BIN_DIR}/setupmobile.sh  "$SUB_DOMAIN" "$CLIENT_ID" "$CLIENT_NAME"
${BIN_DIR}/exportwelcome.sh  "$SUB_DOMAIN" "$CLIENT_ID"  "$CLIENT_NAME"
#${BIN_DIR}/setupclientdropbox.sh  "$SUB_DOMAIN" "$CLIENT_ID"  "$CLIENT_NAME"
