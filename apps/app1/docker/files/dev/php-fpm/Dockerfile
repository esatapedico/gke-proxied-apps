FROM php:7.4-fpm-alpine

# PHPIZE for alpine
RUN apk add --no-cache \
    $PHPIZE_DEPS \
    openssl-dev \
    bash \
    git

# PECL extensions
RUN pecl channel-update pecl.php.net

# xdebug
RUN pecl install xdebug-2.9.6 && \
    docker-php-ext-enable xdebug

# composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN wget https://get.symfony.com/cli/installer -O - | bash
RUN mv /root/.symfony/bin/symfony /usr/local/bin/symfony
