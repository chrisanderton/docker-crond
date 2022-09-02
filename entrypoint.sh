#!/bin/sh

set -e

# note that this can cause some breakage if variables have special characters
# see: https://stackoverflow.com/questions/27771781/how-can-i-access-docker-set-environment-variables-from-a-cron-job
printenv > /etc/environment

USER=root

# /var/spool/cron/crontabs/ is symlink of /etc/crontabs/
CRONTAB="/var/spool/cron/crontabs/$USER"
PERIODS="/etc/periodic"

# this is weird, could maybe be in a file. it's mostly the default, but someone somwhere said anything that appends would do
# so on each restart ¯\_(ツ)_/¯
cat <<EOF > $CRONTAB
*/1 * * * * run-parts /etc/periodic/1min
*/5 * * * * run-parts /etc/periodic/5min
*/10 * * * * run-parts /etc/periodic/10min
*/15 * * * * run-parts /etc/periodic/15min
0 * * * * run-parts /etc/periodic/hourly
0 2 * * * run-parts /etc/periodic/daily
0 3 * * 6 run-parts /etc/periodic/weekly
0 5 1 * * run-parts /etc/periodic/monthly
EOF

# if cron is provided, override the default crontab
if [ -n "$CRON" ]; then
  if [ "$APPEND" = "true" ]; then
    echo "$CRON" >> $CRONTAB
  else
    echo "$CRON" > $CRONTAB
  fi
fi

chown "$USER:$USER" "$CRONTAB"
chmod 600 "$CRONTAB"

mkdir -p $PERIODS/1min $PERIODS/5min $PERIODS/10min
chown -R "$USER:$USER" $PERIODS

exec "crond -f" "$@"
