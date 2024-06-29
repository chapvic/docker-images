ARG REGISTRY

FROM $REGISTRY/alpine:slim AS samba
RUN apk add --no-cache --update samba cifs-utils
ADD source /
STOPSIGNAL SIGINT
EXPOSE 139/tcp 445/tcp
HEALTHCHECK --interval=5s --timeout=3s CMD ["healthcheck"]
EXPOSE 143/tcp 445/tcp
ENTRYPOINT ["entrypoint"]
