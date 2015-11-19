#!/bin/bash
# Specify client in first argument from CLI
SUB_DOMAIN=$1
CLIENT_ID=$2
CLIENT_NAME=$3

WEBAPP="/opt/entermediadb/webapp"
CATALOG="$WEBAPP/WEB-INF/data/$CLIENT_ID/catalog"

mkdir $WEBAPP/$CLIENT_ID/
cp -rp $WEBAPP/template/*  $WEBAPP/$CLIENT_ID/

echo 'Copying system users/groups'
mkdir -p $CATALOG/users
cp -rp $WEBAPP/WEB-INF/data/system/users/admin.xml $CATALOG/users
mkdir -p $CATALOG/groups
cp -rp $WEBAPP/WEB-INF/data/system/groups/*.xml $CATALOG/groups
echo 'Linking base.xml'
mkdir -p $WEBAPP/$CLIENT_ID/catalog
ln -s /usr/share/entermediadb/common/catalog/configuration $WEBAPP/$CLIENT_ID/catalog/

mkdir -p $CATALOG/lists/app/
sed "s:%client_id:$CLIENT_ID:g;s:%client_name:$CLIENT_NAME:g;s:%sub_domain:$SUB_DOMAIN:g" < /usr/share/entermediadb/common/catalog/lists/app/custom.xml >$CATALOG/lists/app/custom.xml

mkdir -p $CATALOG/lists/searchtypes/
sed "s:%client_id:$CLIENT_ID:g;s:%client_name:$CLIENT_NAME:g;s:%sub_domain:$SUB_DOMAIN:g" < /usr/share/entermediadb/common/catalog/searchtypes/custom.xml >$CATALOG/lists/searchtypes/custom.xml

mkdir -p $CATALOG/lists/catalogsettings/
sed "s:%client_id:$CLIENT_ID:g;s:%client_name:$CLIENT_NAME:g;s:%sub_domain:$SUB_DOMAIN:g" < /usr/share/entermediadb/common/catalog/catalogsettings/custom.xml >$CATALOG/lists/catalogsettings/custom.xml


outfile="<page>\n   <inner-layout>/theme/layouts/landing.html</inner-layout>\n  <property name=\"clientid\">$CLIENT_ID</property>\n <property name=\"clientname\">$CLIENT_NAME</property>\n <property name=\"clientdomainprefix\">$CLIENT_DOMAIN</property>\n <property name=\"virtual\">true</property>\n</page>"
echo -e $outfile > $WEBAPP/$CLIENT_ID/index.xconf


outfile="<page> <property name=\"fallbackdirectory\">/WEB-INF/base/emshare</property> <property name=\"title\">$CLIENT_NAME - EMShare</property> <property name=\"appmodule\">asset</property> <property name=\"themeid\">emsharedefault</property> <property name=\"catalogid\">$CLIENT_ID/catalog</property> <property name=\"applicationid\">$CLIENT_ID/emshare</property></page>"
echo -e $outfile > $WEBAPP/$CLIENT_ID/emshare/_site.xconf

outfile="<page> <property name=\"fallbackdirectory\">/WEB-INF/base/mediadb</property> <property name=\"title\">$CLIENT_NAME - EMShare</property> <property name=\"appmodule\">asset</property> <property name=\"themeid\">emsharedefault</property> <property name=\"catalogid\">$CLIENT_ID/catalog</property> <property name=\"applicationid\">$CLIENT_ID/emshare</property></page>"
echo -e $outfile > $WEBAPP/$CLIENT_ID/mediadb/_site.xconf

outfile="<page><property name=\"fallbackdirectory\">/media/catalog</property><property name=\"catalogid\">$CLIENT_ID/catalog</property></page>"
echo -e $outfile > $WEBAPP/$CLIENT_ID/catalog/_site.xconf

