# syntax=docker/dockerfile:1.8.1

ARG REGISTRY

FROM $REGISTRY/alpine-dev AS redis-builder
ARG REDIS_VERSION \
    REDIS_SOURCE
RUN git clone -b $REDIS_VERSION $REDIS_SOURCE redis
WORKDIR /src/redis
RUN make BUILD_TLS=yes
RUN make install && cp -f redis.conf /usr/local/bin/

FROM $REGISTRY/alpine
ARG PUID=${PUID:-1000} \
    PGID=${PGID:-1000} \
    REDIS_VERSION
COPY --from=redis-builder /usr/local/bin /usr/local/bin
ADD ./source /
RUN groupadd -g $PGID redis && \
    useradd -g $PGID -u $PUID -d /data -s /sbin/nologin redis && \
    chmod 777 /var/run
ENV REDIS_VERSION=$REDIS_VERSION
STOPSIGNAL SIGINT
EXPOSE 6379/tcp
WORKDIR /data
HEALTHCHECK --interval=5s --timeout=3s CMD ["healthcheck"]
ENTRYPOINT ["entrypoint"]
