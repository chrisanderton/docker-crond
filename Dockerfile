FROM alpine:3.16.2

COPY entrypoint.sh /usr/bin/entrypoint.sh

RUN apk add --update --no-cache \
    bash \
    coreutils \
    gettext \
    jq \
    curl && \
    apk add --no-cache --upgrade grep && \
    chmod +x /usr/bin/entrypoint.sh
   
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["-l", "8", "-d", "8", "/dev/stdout"]
