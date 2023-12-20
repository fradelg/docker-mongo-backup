FROM mongo:7.0.0
LABEL maintainer "Fco. Javier Delgado del Hoyo <frandelhoyo@gmail.com>"

RUN apt-get update && apt-get install -y cron && rm -rf /var/lib/apt/lists/*

ENV CRON_TIME="0 0 * * *" \
    MONGO_HOST="mongo" \
    MONGO_PORT="27017"

COPY ["run.sh", "backup.sh", "restore.sh", "/"]
RUN chmod u+x /run.sh /backup.sh /restore.sh

RUN mkdir /backup
VOLUME ["/backup"]

CMD ["/run.sh"]
