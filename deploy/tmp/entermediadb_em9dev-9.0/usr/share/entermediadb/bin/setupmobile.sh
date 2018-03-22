#!/bin/bash
SUB_DOMAIN=$1
CLIENT_ID=$2
CLIENT_NAME=$3

CLIENT_DOMAIN=$CLIENT_ID
MOBILE_DIR="/opt/entermediadb/common/mobile/em-mobile/installer/cordova"
CLIENT_DIR="/opt/entermediadb/webapp/$CLIENT_ID"
cd $MOBILE_DIR
rm ./config.xml
sed "s:%client_id:$CLIENT_ID:g;s:%client_name:$CLIENT_NAME:g;s:%sub_domain:$SUB_DOMAIN:g" <config.template >config.xml
#cp ./config.xml ./config.xml.$CLIENT_ID

export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_40
export ANDROID_HOME=/opt/entermediadb/common/mobile/android-sdk-linux

$MOBILE_DIR/platforms/android/cordova/clean
$MOBILE_DIR/platforms/android/cordova/build
#cordova build


echo "Copying android project to client directory: $CLIENT_DIR"
NEW_FILE="$CLIENT_DIR/${CLIENT_ID}mobile.apk"
cp -rp $MOBILE_DIR/platforms/android/ant-build/MainActivity-debug.apk $NEW_FILE
echo "Completed setup for $CLIENT_NAME!"

