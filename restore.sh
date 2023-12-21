#!/bin/bash
echo "=> Restore database from \$1"
if [ ! -z "${MONGO_USER}" ] && [ ! -z "${MONGO_PASS}" ]
then
  AUTH_OPTS="-u $MONGO_USER -p $MONGO_PASS"
fi

if [ ! -z "$MONGO_AUTH_DB" ]
then
  AUTH_OPTS="$AUTH_OPTS --authenticationDatabase $MONGO_AUTH_DB"
fi

if mongorestore --gzip --host "$MONGO_HOST" --port "$MONGO_PORT" "$AUTH_OPTS" --archive=\$1
then
    echo "=> Restore succeeded"
else
    echo "=> Restore failed"
fi
