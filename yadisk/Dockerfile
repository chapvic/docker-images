ARG REGISTRY

FROM $REGISTRY/debian:12
ARG YADISK_SOURCE \
    TZ=${TZ:-Europe/Moscow} \
    PUID=${PUID:-1000} \
    PGID=${PGID:-1000}
ENV DEBIAN_FRONTEND=noninteractive
RUN ln -sf /usr/share/zoneinfo/$TZ /etc/localtime; \
    apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade && apt-get -y install wget sudo procps tzdata
RUN wget $YADISK_SOURCE && \
    dpkg -i $(basename $YADISK_SOURCE) && \
    apt-get -y -f install && \
    rm *.deb && \
    apt-get -y purge && apt-get -y autoremove && apt-get -y autoclean
ADD source /
RUN groupadd -g $PGID yandex && useradd -u $PUID -g $PGID -d /yandex -s /sbin/nologin -m yandex
ENV SHELL=/bin/bash \
    TZ=$TZ \
    PUID=$PUID \
    PGID=$PGID \
    CL_NONE="\e[0;0m"\
    CL_RED="\e[1;31m"\
    CL_GREEN="\e[1;32m"\
    CL_YELLOW="\e[1;33m"\
    CL_BLUE="\e[1;34m"\
    CL_MAGENTA="\e[1;35m"\
    CL_CYAN="\e[0;36m"\
    CL_WHITE="\e[1;37m"
STOPSIGNAL SIGINT
ENTRYPOINT ["entrypoint"]
