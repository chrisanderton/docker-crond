FROM alpine:3.17.1

COPY entrypoint.sh /usr/bin/entrypoint

RUN apk add --update --no-cache \
    bash \
    coreutils \
    gettext \
    jq \
    curl \
    sqlite \
    rclone \
    gnupg \
    xz && \
    apk add --no-cache --upgrade grep && \
    chmod +x /usr/bin/entrypoint && \
    mkdir -p /etc/periodic/1min /etc/periodic/5min /etc/periodic/10min && \
    chown -R root:root /etc/periodic
   
ENTRYPOINT ["/usr/bin/entrypoint"]
CMD ["-l", "8", "-d", "8", "/dev/stdout"]
