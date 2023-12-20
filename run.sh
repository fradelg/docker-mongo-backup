touch /backup.log
tail -F /backup.log &
env > /.env

if [ -n "${INIT_BACKUP}" ]
then
  echo "=> Backup at startup"
  /backup.sh
elif [ -n "${INIT_RESTORE_LATEST}" ]
then
  echo "=> Restore latest backup"
  until nc -z "$MONGO_HOST" "$MONGO_PORT"
  do
      echo "waiting mongodb container..."
      sleep 1
  done
  find /backup -d -maxdepth 1 | tail -1 | xargs /restore.sh
fi

CRONJOB=/etc/cron.d/mongo-cron
CRONENV=/env.sh
if [ ! -f $CRONJOB ]
then
  echo "=> Installing cron job in $CRONJOB ..."
  echo "export MONGO_HOST=$MONGO_HOST" > $CRONENV
  echo "export MONGO_PORT=$MONGO_PORT" >> $CRONENV
  echo "export MONGO_USER=$MONGO_USER" >> $CRONENV
  echo "export MONGO_PASS=$MONGO_PASS" >> $CRONENV
  echo "export MAX_BACKUPS=$MAX_BACKUPS" >> $CRONENV
  echo "${CRON_TIME} /backup.sh >> /backup.log 2>&1" > $CRONJOB
  chmod 600 $CRONJOB
  crontab $CRONJOB
fi

echo "=> Running cron task manager"
exec cron -f
