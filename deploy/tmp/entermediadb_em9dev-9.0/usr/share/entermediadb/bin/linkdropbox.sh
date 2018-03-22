#!/bin/bash
SUB_DOMAIN=$1

CLIENT_DIR="/opt/entermediadb/clients/home/$SUB_DOMAIN"
echo 'Setting up Dropbox configuration'
mkdir ${CLIENT_DIR}
cp -r /opt/entermediadb/common/dropbox-dist/ ${CLIENT_DIR}/.dropbox-dist
HOME="${CLIENT_DIR}/"
${HOME}/.dropbox-dist/dropboxd


