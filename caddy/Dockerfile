ARG REGISTRY

FROM $REGISTRY/golang AS caddy-builder
ARG XCADDY_SOURCE \
    CADDY_VERSION
RUN git clone $XCADDY_SOURCE xcaddy
WORKDIR /src/xcaddy/cmd/xcaddy
RUN go build -o /usr/bin/xcaddy
RUN xcaddy build v${CADDY_VERSION} --output /app/bin/caddy \
    --with github.com/porech/caddy-maxmind-geolocation \
    --with github.com/lindenlab/caddy-s3-proxy \
    --with github.com/greenpau/caddy-security@latest \
    --with github.com/greenpau/caddy-security-secrets-aws-secrets-manager@latest \
    --with github.com/greenpau/caddy-trace@latest \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/caddyserver/forwardproxy
RUN mkdir -p /app/etc


FROM $REGISTRY/alpine:slim AS caddy
ARG CADDY_VERSION \
    PUID=${PUID:-1000} \
    PGID=${PGID:-1000}
COPY --from=caddy-builder --chmod=755 /app /app
ADD source /
WORKDIR /www
RUN <<EOF
set -e
groupadd -g $PGID caddy
useradd -u $PUID -g $PGID -d /app/etc -s /sbin/nologin caddy
chown -R caddy:caddy /app /www
EOF
ENV PATH=/app/bin:$PATH \
    CADDY_VERSION=$CADDY_VERSION
STOPSIGNAL SIGINT
HEALTHCHECK --interval=5s --timeout=3s CMD ["healthcheck"]
ENTRYPOINT ["entrypoint"]
