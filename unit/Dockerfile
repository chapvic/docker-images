ARG REGISTRY

FROM $REGISTRY/alpine-dev AS unit-builder
ARG UNIT_SOURCE \
    UNIT_VERSION \
    NJS_SOURCE \
    NJS_VERSION
RUN git clone -b ${NJS_VERSION} ${NJS_SOURCE} njs
RUN git clone -b ${UNIT_VERSION} ${UNIT_SOURCE} unit
WORKDIR /src/njs
RUN ./configure --no-zlib --no-libxml2 && make -j$(nproc)
ENV PKG_CONFIG_PATH=/src/njs
WORKDIR /src/unit
RUN ./configure --prefix=/app \
 --bindir=/app/bin \
 --sbindir=/app/bin \
 --libdir=/app/lib \
 --modulesdir=/app/lib/modules \
 --localstatedir=/app/var \
 --logdir=/app/var/log \
 --runstatedir=/run \
 --datarootdir=/app/share \
 --control=unix:/run/unit.sock \
 --openssl --njs \
 --cc-opt="-I../njs/build/ -I../njs/src/" \
 --ld-opt="-L../njs/build/" && \
 make -j$(nproc) && make unitd-install
RUN cp -r ./tools/ /app/bin && \
 mkdir -p /app/config && \
 mkdir -p /app/share/welcome && \
 cp pkg/docker/welcome.* /app/share/welcome && \
 sed -i 's,/usr/share/unit,/app/share,g' /app/share/welcome/welcome.json && \
 sed -i 's,/var/run,/run,g; s,control.unit,unit,g;' /app/share/welcome/welcome.html && \
 sed -i 's,/var/run,/run,g; s,control.unit,unit,g;' /app/share/welcome/welcome.md


FROM $REGISTRY/alpine:slim AS unit
ARG PUID=${PUID:-1000} \
    PGID=${PGID:-1000}
COPY --from=unit-builder /app /app
ADD source /
RUN <<EOF
set -e
apk add --no-cache --upgrade pcre
groupadd -g $PGID unit
useradd -u $PUID -g $PGID -s /sbin/nologin -d /app/share unit
chown -R unit:unit /app
EOF
ENV PATH=/app/bin:$PATH
STOPSIGNAL SIGINT
EXPOSE 80/tcp
HEALTHCHECK --interval=5s --timeout=3s CMD ["healthcheck"]
ENTRYPOINT ["entrypoint"]
