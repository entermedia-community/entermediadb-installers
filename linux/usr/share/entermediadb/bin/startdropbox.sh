#!/bin/bash -x
CLIENT_ROOT="/opt/entermediadb/clients/home";
##if [[ -z "$1" ]]; then
	##cd $CLIENT_ROOT;
CLIENTS="$CLIENT_ROOT/*";
##else
##	CLIENTS=($1)
##fi

rm -f ~/.dropbox/dropbox.pid

rm -f /tmp/dropboxall.log

for CLIENT in $CLIENTS; do
	##CLIENT=$CLIENT_ROOT/$CLIENT
	if [[ -f "$CLIENT/.dropbox/unlink.db" ]]; then
		echo "Starting dropbox client for $CLIENT"
		HOME="$CLIENT"
		rm -f "$CLIENT/.dropbox/dropbox.pid"
		LOG_LOC="$CLIENT/dropbox.log"		
		echo "starting $CLIENT" >> $LOG_LOC >> /tmp/dropboxall.log
		nohup $CLIENT/.dropbox-dist/dropboxd >> $LOG_LOC >> /tmp/dropboxall.log 2>&1 &
		#sleep 5
	fi
done
