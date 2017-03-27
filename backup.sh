#!/bin/bash

DATE=`date +%Y.%m.%d.%H.%M`
OUTPUT=/backup/$MONGO_HOST-$DATE.archive

if [ ! -z "${MONGO_USER}" ] && [ ! -z "${MONGO_PASS}" ]
then
  AUTH_OPTS="-u $MONGO_USER -p $PASS"
fi

echo "=> Backup started at $DATE"
mongodump --gzip --host $MONGO_HOST --port $MONGO_PORT $AUTH_OPTS --archive=$OUTPUT

if [ -n "$MAX_BACKUPS" ]; then
  while [ `ls -1 /backup | wc -l` -gt "$MAX_BACKUPS" ];
  do
    TARGET=`ls -1 /backup | sort | head -n 1`
    echo "Backup \${TARGET} is deleted"
    rm -rf /backup/\${TARGET}
  done
fi

echo "=> Backup done"
