# docker-crond

Lightweight image to run `crond`. Includes some additional packages to help with scripts you might need to write/run: bash, coreutils, gettext, jq, curl, sqlite, rclone, gnupg, xz.

Entrypoint runs `crond -f`; default `CMD` sets up for logging with `-l 8 -d 8 /dev/stdout` and can be overridden.

Default crontab includes some additional periods for simple tasks. Placing files in `/etc/periodic/[period]` where period is `1 min`, `5 min`, `10 min`, `15 min`, `hourly`, `daily`, `weekly` or `monthly` will execute on the given repeating schedule. Scripts to be executed periodically can be mounted read-only; ownership doesn't seem to matter, just make sure there is no file extension and that the first line includes the [shebang](https://linuxhandbook.com/shebang/).

Supplying a crontab formatted file to the `CRONTAB` environment variable will append to the default root crontab (set REPLACE to true to change this behaviour)
