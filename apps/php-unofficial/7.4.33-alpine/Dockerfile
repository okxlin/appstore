#Reference Links ：https://github.com/joseluisq/alpine-php-fpm/blob/master/8.1-fpm/Dockerfile

FROM php:8.3.13-fpm-alpine

ARG UNAME=www-data
ARG UGROUP=www-data
ARG UID=1000
ARG GID=1000

RUN apk --no-cache add shadow

RUN usermod  --uid $UID $UNAME
RUN groupmod --gid $GID $UGROUP

# define timezone
RUN apk --no-cache add tzdata
RUN echo "Asia/Shanghai" > /etc/timezone

# install dependencies
RUN set -eux \
    && apk add --no-cache \
        c-client \
        ca-certificates \
        freetds \
        freetype \
        gettext \
        gmp \
        icu-libs \
        imagemagick \
        imap \
        libexecinfo \
        libffi \
        libgmpxx \
        libintl \
        libjpeg-turbo \
        libpng \
        libpq \
        librdkafka \
        libssh2 \
        libstdc++ \
        libtool \
        libxpm \
        libxslt \
        libzip \
        make \
        rabbitmq-c \
        tidyhtml \
        unixodbc \
        vips \
        yaml \
        libmemcached-dev \
        libmcrypt-dev \
        autoconf \
        gcc \
        g++ \
        zlib-dev \
        jpeg-dev \
        libpng-dev \
        libwebp-dev \
        freetype-dev \
        icu-dev \
        libzip-dev \
        imap-dev \
        krb5-dev \
        openssl-dev \
        libxslt-dev \
        gettext-dev \
        curl-dev \
        oniguruma-dev \
        imagemagick-dev 


# memcached
RUN pecl install memcached
RUN docker-php-ext-enable memcached

# mcrypt
RUN pecl install mcrypt
RUN docker-php-ext-enable mcrypt

# redis
RUN pecl install redis
RUN docker-php-ext-enable redis

# rar
RUN pecl install rar
RUN docker-php-ext-enable rar

# configure
RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp \
&& docker-php-ext-configure intl \
&& docker-php-ext-configure mysqli --with-mysqli=mysqlnd \
&& docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
&& docker-php-ext-configure zip \
&& docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
&& docker-php-ext-install -j "$(nproc)" \
    gd \
    intl \
    mysqli \
    pdo_mysql \
    zip \
    imap \
    fileinfo \
    xsl \
    bcmath \
    gettext \
    exif \
    curl \
    mbstring

# install imagick
RUN pecl install imagick
RUN docker-php-ext-enable imagick

RUN echo "extension=redis.so" >> /usr/local/etc/php/php.ini

WORKDIR /www


