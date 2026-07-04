ARG PHP_IMAGE
FROM ${PHP_IMAGE}

ARG PHP_EXTENSIONS
ARG CONTAINER_PACKAGE_URL

RUN if [ "${CONTAINER_PACKAGE_URL}" != "https://deb.debian.org" ]; then \
        sed -i \
            -e "s|http://snapshot.debian.org/archive/debian|${CONTAINER_PACKAGE_URL}|g" \
            -e "s|http://deb.debian.org/debian|${CONTAINER_PACKAGE_URL}/debian|g" \
            -e "s|http://snapshot.debian.org/archive/debian-security|${CONTAINER_PACKAGE_URL}|g" \
            -e "s|http://security.debian.org/debian-security|${CONTAINER_PACKAGE_URL}/debian-security|g" \
            /etc/apt/sources.list && \
        apt-get update; \
    fi

COPY ./data /tmp/data

COPY data/install-ext /usr/local/bin/
RUN chmod uga+x /usr/local/bin/install-ext

ENV PHP_INI_SCAN_DIR=/usr/local/etc/php/conf.d

RUN pear config-set php_ini /usr/local/etc/php/php.ini

RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]

WORKDIR /www
