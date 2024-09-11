# syntax=docker/dockerfile:1.8.1

ARG REGISTRY

FROM $REGISTRY/golang:latest AS golang-layer

FROM lscr.io/linuxserver/code-server:latest
ARG PUID=${PUID:-1000} \
    PGID=${PGID:-1000} \
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y dist-upgrade && \
    apt-get -y install bash-completion build-essential gcc g++ make cmake automake autoconf bison pkg-config libtool && \
    apt-get -y autoremove && \
    apt-get clean
ADD source /
COPY --from=golang-layer /opt/go /opt/go
ENV PUID=$PUID \
    PGID=$PGID \
    PATH=/opt/go/bin:$PATH
HEALTHCHECK --interval=5s --timeout=3s CMD ["healthcheck"]
