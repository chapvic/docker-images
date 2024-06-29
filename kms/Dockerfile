ARG REGISTRY

FROM $REGISTRY/alpine-dev AS kms-builder
ARG KMS_SOURCE
RUN git clone $KMS_SOURCE kms
WORKDIR /src/kms
RUN make vlmcsd PROGRAM_NAME=/usr/local/bin/vlmcsd
ADD source /

FROM $REGISTRY/alpine:slim AS kms
COPY --from=kms-builder /usr/local/bin /usr/local/bin
EXPOSE 1688
STOPSIGNAL SIGINT
HEALTHCHECK --interval=5s --timeout=3s CMD ["healthcheck"]
ENTRYPOINT ["entrypoint"]
