# docker-rclone-sync

Perform an [rclone](http://rclone.org) sync based on a cron schedule, with [healthchecks.io](https://healthchecks.io) monitoring.

## Usage
```
docker create \
  --name=rclone-sync \
  --env CRON="0 * * * *" \  
  --env CHECK_URL=http://example.com/asdf1234 \
  --env SYNC_SRC=/path/to/src \
  --env SYNC_DEST="gdrive:path" \
  --env SYNC_OPTS="-v" \
  --env TZ="America/Edmonton" \
  --volume <path to data>:/config \
  radpenguin/rclone-sync
```

## Parameters
The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side. 
```
--volume /config - config file and for rclone
--env CRON - cron schedule, defaults to sync hourly
--env CHECK_URL - monitoring service url to GET after a successful sync
--env SYNC_SRC - source location for rclone sync command
--env SYNC_DEST - destination location for rclone sync command
--env SYNC_OPTS - additional options for rclone sync command. Defaults to `-v`
--env TZ - the timezone to use for the cron and log. Defaults to `America/Edmonton`
```

It is based on alpine linux. For shell access while the container is running, `docker exec -it rclone-sync /bin/bash`.

See [rclone sync docs](https://rclone.org/commands/rclone_sync/) for source/dest syntax and additional options.
