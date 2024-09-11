# syntax=docker/dockerfile:1.8.1

ARG REGISTRY

FROM $REGISTRY/alpine
ARG PUID=${PUID:-1000} \
    PGID=${PGID:-1000}
RUN <<EOF
set -e
apk add --no-cache --upgrade apache2 apache2-ctl apache2-error apache2-http2 apache2-icons apache2-proxy apache2-ssl apache2-utils
cp -rf /etc/apache2 /etc/apache2.dist
groupmod -g $PGID apache
usermod -u $PUID apache
chown -R apache:apache /etc/apache2 /var/log/apache2 /run/apache2
EOF
ADD source /
STOPSIGNAL SIGINT
EXPOSE 80/tcp 443/tcp
HEALTHCHECK --interval=5s --timeout=3s CMD ["healthcheck"]
ENTRYPOINT ["entrypoint"]
