# syntax=docker/dockerfile:1.8.1

ARG REGISTRY

FROM $REGISTRY/golang AS prom-builder
ARG PROMETHEUS_SOURCE \
    PROMETHEUS_VERSION
RUN apk add --no-cache --upgrade nodejs npm
RUN git clone -b v${PROMETHEUS_VERSION} ${PROMETHEUS_SOURCE} prometheus
WORKDIR /src/prometheus
RUN make build
RUN strip -s prometheus promtool


FROM $REGISTRY/alpine
ARG PUID=${PUID:-1000} \
    PGID=${PGID:-1000}
RUN mkdir -p /app/bin /app/data /app/etc
COPY --from=prom-builder /src/prometheus/prometheus /src/prometheus/promtool /app/bin
COPY --from=prom-builder /src/prometheus/documentation/examples/prometheus.yml /app/etc/prometheus.yml
COPY --from=prom-builder /src/prometheus/console_libraries /app/etc/console_libraries
COPY --from=prom-builder /src/prometheus/consoles /app/etc/consoles
WORKDIR /app
RUN groupadd -g $PGID prometheus && \
    useradd -g $PGID -u $PUID -d /app prometheus && \
    chown -R prometheus:prometheus /app
ENV PATH=/app/bin:$PATH
USER prometheus
EXPOSE 9090/tcp
ENTRYPOINT [ "prometheus" ]
CMD [ "--config.file=/app/etc/prometheus.yml", \
    "--storage.tsdb.path=/app/data", \
    "--web.console.libraries=/app/etc/console_libraries", \
    "--web.console.templates=/app/etc/consoles" ]
