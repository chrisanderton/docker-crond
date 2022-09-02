# docker-crond

Lightweight image to run `crond`.

Entrypoint runs `crond -f`; default `CMD` sets up for logging and can be overridden.

Default crontab includes some additional periods for simple tasks - placing files in `/etc/periodic/[period]` where period is `1 min`, `5 min`, `10 min`, `15 min`, `hourly`, `daily`, `weekly` or `monthly` will execute on the given repeating schedule. Permissions for files mounted here are updated in the entrypoint.

Supplying a crontab formatted file to the `CRON` environment variable will overwrite the default crontab (if you want to retain the periods, set APPEND variable to true)
