# syntax=docker/dockerfile:1.8.1

ARG REGISTRY

FROM $REGISTRY/alpine-dev AS ocis-generator
ARG OCIS_SOURCE \
    OCIS_VERSION
RUN git clone -b v$OCIS_VERSION $OCIS_SOURCE ocis
WORKDIR /src/ocis/ocis
RUN make ci-node-generate


FROM $REGISTRY/golang AS ocis-builder
COPY --from=ocis-generator /src/ocis /src/ocis
WORKDIR /src/ocis/ocis
RUN CGO_ENABLED=0 LDFLAGS="-extldflags=-static -s" make ci-go-generate build


FROM $REGISTRY/alpine:slim AS ocis
ARG PUID=${PUID:-1000} \
    PGID=${PGID:-1000}
COPY --from=ocis-builder /src/ocis/ocis/bin /usr/local/bin
RUN groupadd -g ${PGID} ocis && \
    useradd -g ${PGID} -u ${PUID} -d /data -m ocis
EXPOSE 9100/tcp
ENTRYPOINT ["ocis"]
CMD ["server"]
