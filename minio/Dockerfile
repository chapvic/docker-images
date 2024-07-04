ARG REGISTRY

FROM $REGISTRY/golang AS minio-builder
ARG MINIO_SOURCE \
    MINIO_VERSION
RUN git clone -b ${MINIO_VERSION} ${MINIO_SOURCE} minio
WORKDIR /src/minio
RUN sed -i 's/Version =.*/Version = "'$MINIO_VERSION'"/g' cmd/build-constants.go && \
    sed -i 's/CommitID =.*/CommitID = "(Release)"/g' cmd/build-constants.go && \
    sed -i 's/ReleaseTag =.*/ReleaseTag = "'$MINIO_VERSION'"/g' cmd/build-constants.go && \
    sed -i 's/CopyrightYear =.*/CopyrightYear = "'$(date +%Y)'"/g' cmd/build-constants.go && \
    go build -o /usr/local/bin/minio
ADD source /


FROM $REGISTRY/alpine:slim AS minio
ARG MINIO_VERSION \
    PUID ${PUID:-1000} \
    PGID ${PGID:-1000}
RUN apk add --no-cache --upgrade lsof net-tools util-linux
COPY --from=minio-builder /usr/local/bin /usr/local/bin
ENV MINIO_VERSION=$MINIO_VERSION
RUN <<EOF
set -e
groupadd -g $PGID minio
useradd -u $PUID -g $PGID -d /data -s /sbin/nologin -m minio
EOF
EXPOSE 9000/tcp
HEALTHCHECK --interval=5s --timeout=3s CMD ["healthcheck"]
ENTRYPOINT ["entrypoint"]
