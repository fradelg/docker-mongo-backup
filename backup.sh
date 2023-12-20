#!/bin/bash
source /env.sh
OPTS="--gzip"
DATE=$(date +%Y.%m.%d.%H.%M)
OUTPUT=/backup/$MONGO_HOST-$DATE.archive.gz

if [ ! -z "$MONGO_USER" ]
then
  OPTS="$OPTS --username $MONGO_USER"
fi

if [ ! -z "$MONGO_PASS" ]
then
  OPTS="$OPTS --password $MONGO_PASS"
fi

if [ ! -z "$MONGO_DB" ]
then
  OPTS="$OPTS --db $MONGO_DB"
fi

if [ ! -z "$MONGO_AUTH_DB" ]
then
  OPTS="$OPTS --authenticationDatabase $MONGO_AUTH_DB"
fi

echo "=> Backup started at $DATE"
mongodump --forceTableScan $OPTS --host "$MONGO_HOST" --port "$MONGO_PORT" --archive="$OUTPUT"

if [ -n "$MAX_BACKUPS" ]; then
  while [ "$(find /backup -maxdepth 1 | wc -l)" -gt "$MAX_BACKUPS" ]
  do
    TARGET=$(find /backup -maxdepth 1 | sort | head -n 1)
    rm -rf "$TARGET"
    echo "Backup $TARGET is deleted"
  done
fi

echo "=> Backup done"
