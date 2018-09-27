#!/bin/sh

# fail fast
set -e -u

# Configure the timezone
cp /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ > /etc/timezone

# Configure rclone
if [[ $( rclone config show | grep "empty config" | wc -l ) != "0" ]]; then
  echo "INFO: Starting rclone config"
  rclone config $RCLONE_OPTS
fi

# Tidy up previous sync jobs
rm -f /tmp/sync.pid

# Setup cron schedule
crontab -d
echo "$CRON /sync.sh >> /dev/stdout 2>&1" > /tmp/crontab.tmp
crontab /tmp/crontab.tmp
rm /tmp/crontab.tmp

# Start cron
echo "INFO: Starting crond ..."
crond -b -l 0 -L /dev/stdout
echo "INFO: crond started"
