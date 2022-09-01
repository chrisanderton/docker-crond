#!/bin/sh

set -e

# note that this can cause some breakage if variables have special characters
# see: https://stackoverflow.com/questions/27771781/how-can-i-access-docker-set-environment-variables-from-a-cron-job
printenv > /etc/environment

USER=root

# /var/spool/cron/crontabs/ is symlink of /etc/crontabs/
CRONTAB="/var/spool/cron/crontabs/$USER"
$PERIOD="/etc/periodic"

cat <<EOF > $CRONTAB
*/1	*	*	*	*	run-parts /etc/periodic/1min
*/5	*	*	*	*	run-parts /etc/periodic/5min
*/10	*	*	*	*	run-parts /etc/periodic/10min
*/15	*	*	*	*	run-parts /etc/periodic/15min
0	*	*	*	*	run-parts /etc/periodic/hourly
0	2	*	*	*	run-parts /etc/periodic/daily
0	3	*	*	6	run-parts /etc/periodic/weekly
0	5	1	*	*	run-parts /etc/periodic/monthly
EOF

# if cron is provided, override the default crontab
if [ -n "$CRON" ]; then
  echo -e "$CRON" > "$CRONTAB"
fi

chown "$USER:$USER" "$CRONTAB"
chmod 600 "$CRONTAB"

mkdir -p $PERIOD/1min $PERIOD/5min $PERIOD/10min
chown -R "$USER:$USER" $PERIOD

exec "crond -f" "$@"
