#!/bin/bash
CLIENT_ROOT="/opt/entermediadb/clients/home";
if [[ -z "$1" ]]; then
	##cd $CLIENT_ROOT;
	CLIENTS="$CLIENT_ROOT/*";
else
	CLIENTS=($1)
fi

rm -f ~/.dropbox/dropbox.pid

for CLIENT in $CLIENTS; do
	if [[ -d "$CLIENT/.dropbox/instance_db" ]]; then
		echo "Starting dropbox client for $CLIENT"
		HOME="$CLIENT"
		rm -f "$CLIENT/.dropbox/dropbox.pid"
		$CLIENT/.dropbox-dist/dropboxd >> /tmp/log.log 2>&1 & disown
		sleep 5
	fi
done
echo "Clients all started"
