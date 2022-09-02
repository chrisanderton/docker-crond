FROM alpine:3.16.2

COPY entrypoint.sh /usr/bin/entrypoint

RUN apk add --update --no-cache \
    bash \
    coreutils \
    gettext \
    jq \
    curl && \
    apk add --no-cache --upgrade grep && \
    chmod +x /usr/bin/entrypoint && \
    mkdir -p /etc/periodic/1min /etc/periodic/5min /etc/periodic/10min && \
    chown -R root:root /etc/periodic
   
ENTRYPOINT ["/usr/bin/entrypoint"]
CMD ["-l", "8", "-d", "8", "/dev/stdout"]
