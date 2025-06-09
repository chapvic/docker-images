# syntax=docker/dockerfile:1.8.1

ARG REGISTRY

FROM $REGISTRY/golang AS onedrive-builder
ARG ONEDRIVE_SOURCE \
    ONEDRIVE_VERSION \
    GOSU_SOURCE \
    GOSU_VERSION
RUN git clone -b ${GOSU_VERSION} ${GOSU_SOURCE} gosu && cd gosu && go build -o /usr/local/bin/gosu
RUN git clone -b v${ONEDRIVE_VERSION} ${ONEDRIVE_SOURCE}
WORKDIR /src/onedrive
RUN apk add --no-cache --upgrade dbus-dev
RUN autoreconf -fiv && ./configure && make clean && make -j$(nproc) && make install
RUN cp -f contrib/docker/entrypoint.sh /usr/local/bin/entrypoint


FROM $REGISTRY/alpine AS onedrive
ARG ONEDRIVE_VERSION \
    PUID=${PUID:-1000} \
    PGID=${PGID:-1000}
COPY --from=onedrive-builder /usr/local/bin /usr/local/bin
RUN <<EOF
set -e
apk add --no-cache --upgrade dbus libcurl libgcc sqlite-libs ldc-runtime
mkdir -p /onedrive/conf /onedrive/data
EOF
ENV ONEDRIVE_VERSION=$ONEDRIVE_VERSION \
    ONEDRIVE_UID=$PUID \
    ONEDRIVE_GID=$PGID
ENTRYPOINT ["entrypoint"]
