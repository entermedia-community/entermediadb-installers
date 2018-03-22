#!/bin/bash
CLIENT_ROOT="/opt/entermediadb/clients/home";
if [[ -z "$1" ]]; then
	read -r -p 'Stop all dropboxes? [y/N] ' response
	case $response in
    	[yY][eE][sS]|[yY]) 
       		echo $(killall dropbox)
			exit
        	;;
    	*)
        	echo Cancelling...
			exit
        	;;
	esac
fi
PROCS=($(pgrep dropbox))
CLIENT=$1
DONE=0
for PROC in ${PROCS[@]}; do
	if [[ $(ps "$PROC" | grep "$CLIENT_ROOT/$CLIENT/.dropbox-dist") ]]; then
		echo "Stopping dropbox client for $CLIENT"
		DONE=$DONE+1
	fi
done
[[ $DONE -gt 0 ]] || echo No dropbox found for $CLIENT
