FROM php:alpine
MAINTAINER PIVARD Julien <pivardjulien@gmail.com>

# Based on https://hub.docker.com/r/instrumentisto/phpdoc/
# Install phpDocumentor executable
ADD https://github.com/phpDocumentor/phpDocumentor2/releases/download/v3.0.0-alpha.2-nightly-gdff5545/phpDocumentor.phar \
    /usr/local/bin/phpDocumentor.phar
ADD https://github.com/phpDocumentor/phpDocumentor2/releases/download/v3.0.0-alpha.2-nightly-gdff5545/phpDocumentor.phar.pubkey \
    /usr/local/bin/phpDocumentor.phar.pubkey

RUN chmod 755 /usr/local/bin/phpDocumentor.phar \
    && apk add --update --no-cache \
            graphviz \
            icu-libs libxslt \
    && apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing \
            gnu-libiconv \
    && apk add --no-cache --virtual .build-deps \
            icu-dev libxslt-dev \
    && docker-php-ext-install intl xsl \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/* \
    && addgroup -g 1000 -S app \
    && adduser -u 1000 -S app -G app \
    && chown app: /usr/local/bin/phpDocumentor.phar.pubkey

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

VOLUME ["/app"]
WORKDIR /app

USER app

ENTRYPOINT ["/usr/local/bin/phpDocumentor.phar"]
