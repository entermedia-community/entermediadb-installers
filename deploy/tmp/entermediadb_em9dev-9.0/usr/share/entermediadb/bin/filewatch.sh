WATCHED=$1
FILE=$WATCHED
WHO=$2
if [ ! -d $WATCHED ]; then
  if [ ! -f $WATCHED ]; then
    echo 'Bad file reference!' && exit 0
  else
	WATCHED=`dirname $WATCHED`
  fi
else
  echo 'Directory not yet enabled' && exit 1
fi
while true; do
  change=$(inotifywait -e close_write,moved_to,create $WATCHED)
  change=${change#./ * }
  if [ "$change" = "$FILE" ]; then
    mail -s "$change change" $WHO <<< "A file has changed at $WATCHED";
  fi
done
