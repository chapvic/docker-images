FROM scratch AS alpine-slim-builder
ARG ALPINE_SOURCE \
    TZ
ADD $ALPINE_SOURCE /
ADD rootfs /
RUN <<EOF
set -e
chmod 755 /etc && chmod 700 /root
ln -s /usr/share/zoneinfo/$TZ /etc/localtime
apk add --no-cache --upgrade \
    bash bash-completion \
    ca-certificates coreutils curl \
    openssh-client openssl \
    shadow sqlite sudo su-exec \
    tar tzdata \
    wget
EOF


FROM alpine-slim-builder AS alpine-base-builder
ARG ALPINE_SOURCE \
    TZ
RUN <<EOF
set -e
export ICU=$(apk search --no-cache -q icu-data-full)
[ -n "$ICU" ] || export ICU=icu-data
apk add --no-cache --upgrade $ICU \
    bzip2 \
    docbook-xml docbook-xsl \
    findutils \
    gcompat git gnupg gzip \
    mailcap mc musl-utils \
    pcre p7zip \
    xz \
    yq \
    zip
EOF


FROM scratch AS alpine-slim
ARG LANG \
    TZ
COPY --from=alpine-slim-builder / /
ENV SHELL=/bin/bash\
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


FROM scratch AS alpine-base
ARG LANG \
    TZ
COPY --from=alpine-base-builder / /
ENV SHELL=/bin/bash\
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


FROM alpine-base AS alpine-dev
RUN <<EOF
set -e
apk add --no-cache --upgrade \
    alpine-sdk autoconf automake \
    binutils-gold bison build-base bzip2-dev \
    cmake curl-dev \
    glib \
    icu-dev \
    ldc linux-headers libevent-dev libidn-dev libmcrypt-dev libssh2-dev libtool libxml2-dev libxslt-dev lz4-dev lzo-dev \
    make musl-dev \
    ncurses-dev nodejs npm \
    openssl-dev \
    pcre-dev \
    python3-dev py3-pip \
    readline-dev \
    sqlite-dev \
    yarn
npm install -g pnpm
EOF
WORKDIR /src
CMD ["bash"]
