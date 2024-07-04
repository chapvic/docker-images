ARG REGISTRY \
    ALPINE_VERSION


FROM $REGISTRY/alpine:${ALPINE_VERSION}-slim AS php-default
ARG PHP_NUM \
    PHP_MODULES \
    PECL_MODULES \
    PUID=${PUID:-1000} \
    PGID=${PGID:-1000}
RUN <<EOF
set -e
apk add --no-cache --upgrade gcompat php${PHP_NUM} php${PHP_NUM}-dev $PHP_MODULES $PECL_MODULES
ln -sf /usr/bin/php${PHP_NUM} /usr/bin/php
ln -sf /usr/sbin/php-fpm${PHP_NUM} /usr/sbin/php-fpm
groupadd -g $PGID www
useradd -g $PGID -u $PUID -d /www -s /bin/bash www
mkdir -p /var/log/php${PHP_NUM} /var/run/php${PHP_NUM} /etc/php-dist /www
cp -rf /etc/php${PHP_NUM}/* /etc/php-dist
chown -R www:www /etc/php${PHP_NUM} /var/log/php${PHP_NUM} /var/run/php${PHP_NUM} /etc/php-dist /www
pecl${PHP_NUM} channel-update pecl.php.net
pear${PHP_NUM} update-channels
EOF
COPY source /
RUN get-composer
ENV PHP_INI_DIR=/etc/php${PHP_NUM} \
    PHP_INI_SCAN_DIR=/etc/php${PHP_NUM}/conf.d \
    PHP_WEB_ROOT=/www
WORKDIR $PHP_WEB_ROOT
EXPOSE 9000
ENTRYPOINT ["entrypoint"]


FROM php-default AS php-ioncube
ARG PHP_NUM \
    PHP_VERSION
COPY --chmod=755 ioncube/ioncube_loader_lin_${PHP_VERSION}.so /usr/lib/php${PHP_NUM}/modules/ioncube.so
RUN echo "zend_extension=ioncube" > /etc/php${PHP_NUM}/conf.d/00_ioncube.ini
