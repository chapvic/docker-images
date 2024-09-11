# syntax=docker/dockerfile:1.8.1

ARG REGISTRY

FROM $REGISTRY/alpine-dev AS bind9-builder
ARG BIND9_VERSION \
    BIND9_SOURCE
RUN apk add --no-cache --upgrade libuv-dev libcap-dev libidn2-dev geoip-dev py3-ply pytest json-c-dev lmdb-dev \
    libgss-dev krb5-dev userspace-rcu-dev libmaxminddb-dev libedit-dev jemalloc-dev
RUN git clone -b v$BIND9_VERSION $BIND9_SOURCE bind9
WORKDIR /src/bind9
RUN sed -i -e "s/Development //" -re 's/^(.*\[bind_SRCID\]).*(\)dnl$)/\1, [foxdns]\2/' configure.ac
RUN autoreconf -fi
RUN ./configure --prefix=/app --with-openssl --with-libxml2 --enable-geoip --with-libidn2 \
    --with-json-c --with-lmdb --with-libidn2 --with-gssapi --with-readline=libedit
RUN make -j$(nproc) && make install


FROM $REGISTRY/alpine AS bind9
ARG BIND9_VERSION \
    PUID ${PUID:-1000} \
    PGID ${PGID:-1000}
COPY --from=bind9-builder /app /app
RUN apk add --no-cache --upgrade libxml2 libidn2 libuv libcap geoip json-c lmdb libgss krb5-libs \
    userspace-rcu libmaxminddb libedit jemalloc gettext-envsubst jq
ADD source /
RUN <<EOF
set -e
groupadd -g $PGID named
useradd -u $PUID -g $PGID -d /app/etc -s /sbin/nologin named
mkdir -p /app/etc /app/var/run/named /app/var/log
chown -R named:named /app
EOF
ENV PATH=/app/bin:/app/sbin:$PATH \
    BIND9_VERSION=$BIND9_VERSION
STOPSIGNAL SIGINT
HEALTHCHECK --interval=5s --timeout=3s CMD ["healthcheck"]
ENTRYPOINT ["entrypoint"]
