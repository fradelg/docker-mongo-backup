# mongo-backup

Use mongodump from official mongo image to make regularly backups of your mongo database with cron in `/backup`.

- Use [archive and gzip](https://www.mongodb.com/blog/post/archiving-and-compression-in-mongodb-tools) options of mongodump
- Based on the official [mongo](https://github.com/docker-library/mongo) image

## Usage:

See the `docker-compose.yml` example in this repo. This is a typical setup in a service stack

## Variables

- MONGO_HOST: the hostname or IP, default is mongo
- MONGO_PORT: the port number, default is 27017
- MONGO_USER: the username, default is admin
- MONGO_PASS: the password, default is empty
- CRON_TIME: the interval of cron job to run backup `0 0 * * *` by default, which is every day at 00:00
- MAX_BACKUPS: the number of backups to keep. When reaching the limit, the old backup will be discarded. No limit by default
- INIT_BACKUP: if set, create a backup when the container starts
- INIT_RESTORE_LATEST: if set, restore the latest database backup

## Restore from a backup

To restore database from a certain backup, simply run:

```docker exec fradelg/mongo-backup /restore.sh /backup/2017.08.06.17.19```
