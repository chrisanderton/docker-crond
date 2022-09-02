#!/bin/sh

set -e

# note that this can cause some breakage if variables have special characters
# see: https://stackoverflow.com/questions/27771781/how-can-i-access-docker-set-environment-variables-from-a-cron-job
printenv > /etc/environment

user="root"

# /var/spool/cron/crontabs/ is symlink of /etc/crontabs/
periods="/etc/periodic"

# this is weird here, could maybe be in a file. it's mostly the default crontab
# someone somwhere said anything that appends would do so on each restart ¯\_(ツ)_/¯

crontab_file=$(cat <<EOF
*/1 * * * * run-parts /etc/periodic/1min
*/5 * * * * run-parts /etc/periodic/5min
*/10 * * * * run-parts /etc/periodic/10min
*/15 * * * * run-parts /etc/periodic/15min
0 * * * * run-parts /etc/periodic/hourly
0 2 * * * run-parts /etc/periodic/daily
0 3 * * 6 run-parts /etc/periodic/weekly
0 5 1 * * run-parts /etc/periodic/monthly
EOF
)

# if CRONTAB is provided from docker config, override or append the default crontab
if [ -n "$CRONTAB" ]; then
  if [ "$REPLACE" = "true" ]; then
    crontab_file=$(printf '%s\n' "$CRONTAB")
  else
    crontab_file=$(printf '%s\n\n%s\n' "$crontab_file" "$CRONTAB")
  fi
fi

echo "$crontab_file" | crontab -

# run crond in foreground, allow for other params
exec "crond" "-f" "$@"
