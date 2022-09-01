FROM alpine:3.16.2

RUN apk add --update --no-cache \
    bash \
    coreutils \
    gettext \
    jq \
    curl && \
    apk add --no-cache --upgrade grep
    
ENTRYPOINT ["crond", "-f"]
CMD ["-l", "8", "-d", "8", "/dev/stdout"]
