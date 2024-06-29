ARG REGISTRY

FROM $REGISTRY/golang AS dendrite-builder
ARG DENDRITE_SOURCE \
    DENDRITE_VERSION
ENV CGO_ENABLED=1 \
    CGO_CFLAGS="-D_LARGEFILE64_SOURCE"
RUN mkdir -p /app/etc
RUN git clone -b v${DENDRITE_VERSION} $DENDRITE_SOURCE dendrite
WORKDIR /src/dendrite
RUN go build -v -trimpath -o /app/bin/ ./cmd/...

FROM $REGISTRY/alpine AS dendrite
ARG DENDRITE_VERSION \
    PUID=${PUID:-1000} \
    PGID=${PGID:-1000}
COPY --from=dendrite-builder /app /app
ADD source /
RUN <<EOF
set -e
groupadd -g $PGID matrix
useradd -u $PUID -g matrix -d /app/etc -s /sbin/nologin matrix
chown -R matrix:matrix /app
EOF
ENV PATH=/app/bin:$PATH \
    DENDRITE_VERSION=$DENDRITE_VERSION
WORKDIR /app/etc
STOPSIGNAL SIGINT
HEALTHCHECK --interval=5s --timeout=3s CMD ["healthcheck"]
ENTRYPOINT ["entrypoint"]
