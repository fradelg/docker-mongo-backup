#!/bin/bash
touch /backup.log
tail -F /backup.log &

if [ -n "${INIT_BACKUP}" ]
then
  echo "=> Backup at startup"
  /backup.sh
elif [ -n "${INIT_RESTORE_LATEST}" ]
then
  echo "=> Restore latest backup"
  until nc -z $MONGO_HOST $MONGO_PORT
  do
      echo "waiting mongodb container..."
      sleep 1
  done
  ls -d -1 /backup/* | tail -1 | xargs /restore.sh
fi

CRONTAB=/crontab.conf
if [ ! -f $CRONTAB ]
then
  echo "=> Installing crontab in $CRONTAB ..."
  echo "${CRON_TIME} /backup.sh >> /backup.log 2>&1" > $CRONTAB
  crontab $CRONTAB
fi

echo "=> Running cron task manager"
exec cron -f
