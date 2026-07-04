ARG PHP_IMAGE
FROM ${PHP_IMAGE}

ARG PHP_EXTENSIONS
ARG CONTAINER_PACKAGE_URL


COPY data/install-ext /usr/local/bin/
COPY ./data /tmp/data
RUN chmod uga+x /usr/local/bin/install-ext

ENV PHP_INI_SCAN_DIR=/usr/local/etc/php/conf.d

RUN pear config-set php_ini /usr/local/etc/php/php.ini

RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]

WORKDIR /www
