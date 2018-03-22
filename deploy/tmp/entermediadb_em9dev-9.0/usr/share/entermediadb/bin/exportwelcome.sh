CLIENT_DOMAIN=$1
CLIENT_ID=$2
CLIENT_NAME=$3
#sed "s:%client_name%:$CLIENT_NAME:g;s:%client_id%:$CLIENT_ID:g;s:%client_domain:$CLIENT_DOMAIN:g" </usr/share/entermediadb/common/client_template/index.html.client >/opt/entermediadb/webapp/$CLIENT_ID/index.html
#cp -r /opt/entermediadb/webapp/theme/index_files /opt/entermediadb/webapp/$WEB_FOLDER/

#echo "Exported index.html for $CLIENT_NAME, id: $CLIENT_ID"

outfile="<page>\n   <inner-layout>/theme/layouts/landing.html</inner-layout>\n  <property name=\"clientid\">$CLIENT_ID</property>\n <property name=\"clientname\">$CLIENT_NAME</property>\n <property name=\"clientdomainprefix\">$CLIENT_DOMAIN</property>\n <property name=\"virtual\">true</property>\n</page>"
echo -e $outfile > /opt/entermediadb/webapp/$CLIENT_ID/index.xconf

echo Exported xconf for $CLIENT_NAME
