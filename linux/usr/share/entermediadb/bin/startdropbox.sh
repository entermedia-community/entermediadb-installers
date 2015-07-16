#!/bin/bash
CLIENT_ROOT="/opt/entermediadb/clients/home";
if [[ -z "$1" ]]; then
	cd $CLIENT_ROOT;
	CLIENTS=($(ls -d */));
else
	CLIENTS=($1)
fi
for CLIENT in $CLIENTS; do
	CLIENT_DIR="$CLIENT_ROOT/$CLIENT"
	echo "Starting dropbox client for $CLIENT"
	HOME="$CLIENT_DIR"
	${CLIENT_DIR}/.dropbox-dist/dropboxd &  
	sleep 5
done
