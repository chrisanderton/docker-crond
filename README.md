# docker-crond

Lightweight image to run `crond`.

Entrypoint runs `crond -f`; default `CMD` sets up for logging with `-l 8 -d 8 /dev/stdout` and can be overridden.

Default crontab includes some additional periods for simple tasks. Placing files in `/etc/periodic/[period]` where period is `1 min`, `5 min`, `10 min`, `15 min`, `hourly`, `daily`, `weekly` or `monthly` will execute on the given repeating schedule. Permissions for files mounted here are updated in the entrypoint.

Supplying a crontab formatted file to the `CRONTAB` environment variable will append to the default root crontab (set REPLACE to true to change this behaviour)
