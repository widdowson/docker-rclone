#!/bin/sh

# fail fast
set -e -u

# Locking code retrieved from http://stackoverflow.com/a/1985512 on 2017-03-17
LOCK_FILE=/tmp/$( md5sum "$0" | awk '{print $1}' ).lock
LOCK_FD=99
_lock() {
    flock -$1 $LOCK_FD;
}
_no_more_locking() {
    _lock u;
    _lock xn && rm -f $LOCK_FILE;
}
lock() {
    eval "exec $LOCK_FD>\"$LOCK_FILE\"";
    trap _no_more_locking EXIT;

    # Obtain an exclusive lock immediately or fail
    _lock xn;
}

# Only run one copy of the script at a time
lock || exit 1

# Clean up empty directories in order to speed up rclone
find "$SOURCE" -mindepth 2 -type d -empty -delete

# Set IO Priority to Best Effort (2), lowest priority (7)
/usr/bin/ionice -c2 -n7 -p$$

echo -e "$( date )\t(pid $$)\trclone $CONFIG_OPTS $COMMAND $COMMAND_OPTS $SOURCE $DESTINATION"
rclone $CONFIG_OPTS $COMMAND $COMMAND_OPTS $SOURCE $DESTINATION

if [ ! -z "$HEALTH_URL" ]; then
  echo "$( date ) Pinging $HEALTH_URL"
  curl --silent $HEALTH_URL
fi
