#!/bin/bash
# Specify client in first argument from CLI
SUB_DOMAIN=$1
CLIENT_ID=$2
CLIENT_NAME=$3

WEBAPP="/opt/entermediadb/webapp"
CATALOG="$WEBAPP/WEB-INF/data/$CLIENT_ID/catalog"
echo 'Copying system users/groups'
mkdir -p $CATALOG/users
cp -rp $WEBAPP/WEB-INF/data/system/users/admin.xml $CATALOG/users
mkdir -p $CATALOG/groups
cp -rp $WEBAPP/WEB-INF/data/system/groups/*.xml $CATALOG/groups
echo 'Linking base.xml'
mkdir -p $WEBAPP/$CLIENT_ID/catalog
ln -s /opt/entermediadb/common/catalog/configuration $WEBAPP/$CLIENT_ID/catalog

mkdir -p $CATALOG/lists/searchtypes/

sed "s:%client_id:$CLIENT_ID:g;s:%client_name:$CLIENT_NAME:g;s:%sub_domain:$SUB_DOMAIN:g" < /opt/entermediadb/common/catalog/searchtypes/custom.xml >$CATALOG/lists/searchtypes/custom.xml

mkdir -p $CATALOG/lists/catalogsettings/

sed "s:%client_id:$CLIENT_ID:g;s:%client_name:$CLIENT_NAME:g;s:%sub_domain:$SUB_DOMAIN:g" < /opt/entermediadb/common/catalog/catalogsettings/custom.xml >$CATALOG/lists/catalogsettings/custom.xml

