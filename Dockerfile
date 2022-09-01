FROM alpine:latest

RUN apk add --update --no-cache \
    bash \
    coreutils \
    gettext \
    jq \
    curl && \
    apk add --no-cache --upgrade grep
    
ENTRYPOINT ["crond", "-f", "-l", "8", "-d", "8", "/dev/stdout"]
