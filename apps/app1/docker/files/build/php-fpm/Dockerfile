FROM php:7.4-fpm-alpine

# PHPIZE for alpine
RUN apk add --no-cache \
    $PHPIZE_DEPS \
    openssl-dev \
    bash \
    git

COPY docker/res/php.ini /usr/local/etc/php/php.ini

COPY --chown=www-data app /app

WORKDIR /app

ENV APP_ENV "prod"

USER www-data
