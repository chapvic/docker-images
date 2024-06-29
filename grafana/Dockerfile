ARG REGISTRY

FROM $REGISTRY/alpine:slim
ARG GRAFANA_VERSION \
    GRAFANA_SOURCE \
    GRAFANA_ARCH \
    PUID=${PUID:-1000} \
    PGID=${PGID:-1000}
RUN <<EOF
set -e
wget -O grafana.tar.gz ${GRAFANA_SOURCE}/grafana-${GRAFANA_VERSION}.linux-${GRAFANA_ARCH}.tar.gz
tar xzvf grafana.tar.gz
rm grafana.tar.gz
mv grafana-* app
cp -rf /app/conf /app/conf.dist
groupadd -g $PGID grafana
useradd -g $PGID -u $PUID -s /sbin/nologin -d /app/data grafana
chown -R grafana:grafana /app
EOF
ADD source /
ENV GRAFANA_VERSION=$GRAFANA_VERSION \
    PATH=/app/bin:$PATH
WORKDIR /app/bin
EXPOSE 3000/tcp
HEALTHCHECK --interval=5s --timeout=3s CMD ["healthcheck"]
ENTRYPOINT ["entrypoint"]
