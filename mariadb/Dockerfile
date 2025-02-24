# syntax=docker/dockerfile:1.8.1

ARG REGISTRY

FROM $REGISTRY/alpine-dev:3.18 AS mariadb-builder
ARG MARIADB_SOURCE \
    MARIADB_TAG
RUN apk add --no-cache --upgrade snappy-dev boost-dev
RUN git clone -b ${MARIADB_TAG} --depth=1 ${MARIADB_SOURCE} mariadb
WORKDIR /src/mariadb
RUN git submodule update --init --recursive
WORKDIR /build
RUN cmake --install-prefix=/app \
 -DCMAKE_INSTALL_PREFIX=/app \
 -DMYSQL_DATADIR=/data \
 -DMYSQL_UNIX_ADDR=/app/run/mysqld.sock \
 -DDEFAULT_CHARSET=utf8mb4 \
 -DDEFAULT_COLLATION=utf8mb4_unicode_ci \
 -DINSTALL_SYSCONF2DIR=/app/etc \
 -DWITH_UNIT_TESTS=OFF \
 -DCONC_WITH_UNIT_TESTS=OFF \
 -DPCRE_BUILD_TESTS=OFF \
 -DENABLED_PROFILING=OFF \
 -DPROFILING=OFF \
 -Wno-dev \
 /src/mariadb
RUN make -j$(nproc)
RUN make install


FROM $REGISTRY/alpine AS mariadb
ARG MARIADB_VERSION \
    PUID ${PUID:-1000} \
    PGID ${PGID:-1000}
RUN apk add --no-cache --upgrade openssl libevent libxml2 bzip2 lz4 lzo snappy boost libedit pcre2   # "libexecinfo" removed from 3.17
ENV MARIADB_VERSION=${MARIADB_VERSION} \
    PATH=/app/bin:$PATH
RUN groupadd -g $PGID mysql && \
    useradd -g $PGID -u $PUID -d /data -s /bin/false -m mysql && \
    mkdir -p /app/log /app/run
COPY --from=mariadb-builder --chown=$PUID:$PGID /app /app
ADD source /
STOPSIGNAL SIGINT
WORKDIR /app
EXPOSE 3306/tcp
HEALTHCHECK --interval=5s --timeout=3s CMD ["healthcheck"]
ENTRYPOINT ["entrypoint"]
