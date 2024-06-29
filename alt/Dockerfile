FROM scratch
ARG ALT_SOURCE \
    LANG \
    TZ
ADD $ALT_SOURCE /
ADD rootfs /
RUN ln -sf /usr/share/zoneinfo/$TZ /etc/localtime && \
    apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get -y install curl fonts-console-terminus locales mc openssl p7zip tzdata wget && \
    apt-get -y autoremove && \
    apt-get clean
RUN echo 'SYSFONT=UniCyr_8x16' > /etc/sysconfig/consolefont && \
    rm -rf /root/.z* /root/.tcs* /root/.rpm* /root/.install-log && \
    echo 'ENV=$HOME/.bashrc' >> /root/.bashrc && \
    echo 'USERNAME="root"' >> /root/.bashrc && \
    echo 'export USERNAME ENV PATH' >> /root/.bashrc
ENV SHELL=/bin/bash \
    LANG=$LANG \
    LANGUAGE=$LANG \
    TZ=$TZ \
    CL_NONE="\e[0;0m" \
    CL_GRAY="\e[3;0m" \
    CL_DARK_RED="\e[0;31m" \
    CL_RED="\e[1;31m" \
    CL_DARK_GREEN="\e[0;32m" \
    CL_GREEN="\e[1;32m" \
    CL_DARK_YELLOW="\e[0;33m" \
    CL_YELLOW="\e[1;33m" \
    CL_DARK_BLUE="\e[0;34m" \
    CL_BLUE="\e[1;34m" \
    CL_DARK_MAGENTA="\e[0;35m" \
    CL_MAGENTA="\e[1;35m" \
    CL_DARK_CYAN="\e[0;36m" \
    CL_CYAN="\e[1;36m" \
    CL_WHITE="\e[1;37m"
