ARG REGISTRY

FROM $REGISTRY/golang AS gitea-builder
ARG GITEA_VERSION \
    GITEA_SOURCE \
    CGO_EXTRA_CFLAGS \
    GOPROXY ${GOPROXY:-direct}
ENV TAGS "bindata timetzdata sqlite sqlite_unlock_notify"
RUN git clone -b v${GITEA_VERSION} ${GITEA_SOURCE} gitea
WORKDIR /src/gitea
# -------------------------
# Translation patch (ru-RU)
ADD localization/fix_locale \
    localization/translate \
    localization/translate.ini \
    /opt/
RUN /opt/translate
# -------------------------
ENV CGO_ENABLED=1 \
    CGO_CFLAGS="-D_LARGEFILE64_SOURCE"
RUN make frontend
RUN make backend
RUN go build contrib/environment-to-ini/environment-to-ini.go


FROM $REGISTRY/alpine AS gitea
ARG GITEA_VERSION \
    PUID ${PUID:-1000} \
    PGID ${PGID:-1000}
RUN <<EOF
set -e
apk add --no-cache gettext linux-pam openssh s6 postgresql16-client py3-docutils py3-pygments \
    asciidoctor freetype freetype-dev gcc g++ libpng libffi-dev py-pip python3-dev py3-pip py3-pyzmq pandoc
groupadd -g $PGID git
useradd -g $PGID -u $PUID -s /bin/bash -d /data/git git
echo "git:*" | chpasswd -e
EOF
COPY --from=gitea-builder /src/gitea/docker/root /
COPY --from=gitea-builder /src/gitea/gitea /app/gitea/gitea
COPY --from=gitea-builder /src/gitea/environment-to-ini /usr/local/bin/environment-to-ini
RUN <<EOF
set -e
python3 -m venv /.venv
. /.venv/bin/activate
pip install --upgrade pip && pip install -U setuptools && pip install jupyter docutils rst2html
rm -rf /.venv
chmod 755 /usr/bin/entrypoint /app/gitea/gitea /usr/local/bin/gitea /usr/local/bin/environment-to-ini
chmod 755 /etc/s6/gitea/* /etc/s6/openssh/* /etc/s6/.s6-svscan/*
EOF
ADD source /
ENV UID=$PUID \
    USER=git \
    GITEA_CUSTOM=/data/gitea \
    GITEA_VERSION=$GITEA_VERSION
EXPOSE 22/tcp 3000/tcp
VOLUME ["/data"]
HEALTHCHECK --interval=5s --timeout=3s CMD ["healthcheck"]
ENTRYPOINT ["entrypoint"]
CMD ["s6-svscan", "/etc/s6"]
