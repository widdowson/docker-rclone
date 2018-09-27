#!/bin/sh

# fail fast
set -e -u

# Configure the timezone
cp /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ > /etc/timezone

# Configure rclone
if [[ $( rclone $CONFIG_OPTS config show | grep "empty config" | wc -l ) != "0" ]]; then
  echo "$( date ) Configuring rclone"
  rclone $CONFIG_OPTS config
fi

if [[ "$CRON_ENABLED" != "1" ]; then
  /rclone.sh
else
  # Setup cron schedule
  crontab -d
  echo "$CRON /rclone.sh >> /dev/stdout 2>&1" > /tmp/crontab.tmp
  crontab /tmp/crontab.tmp
  rm /tmp/crontab.tmp

  # Start cron
  echo "$( date ) Starting cron"
  crond -b -l 0 -L /dev/stdout
fi
