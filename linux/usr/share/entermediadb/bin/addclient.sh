#!/bin/bash
WEBAPP=/opt/entermediadb/webapp
echo "Enter client sub-domain (i.e. xyz)"
read SUB_DOMAIN
echo "Enter client id (ex: em_site)"
read CLIENT_ID
echo "Enter client name (ex: EnterMedia)"
read CLIENT_NAME

./configureclientelastic.sh "$SUB_DOMAIN" "$CLIENT_ID" "$CLIENT_NAME"

echo "Go to catalogmanager and add catalog. press enter to continue"
read enter

EMSHARE="$WEBAPP/$CLIENT_ID/emshare"
# Validate request
if [ ! -d $EMSHARE ]; then
    echo '$CLIENT_ID is not an existing client'
    exit 1
fi

./setupmobile.sh  "$SUB_DOMAIN" "$CLIENT_ID" "$CLIENT_NAME"
./exportwelcome.sh  "$SUB_DOMAIN" "$CLIENT_ID"  "$CLIENT_NAME"
#./setupclientdropbox.sh  "$SUB_DOMAIN" "$CLIENT_ID"  "$CLIENT_NAME"


