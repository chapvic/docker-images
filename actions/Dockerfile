ARG REGISTRY

FROM $REGISTRY/alpine AS actions-alpine
ARG TOOLS_URL \
    TOOLS_LIST

# System tools
RUN apk add --no-cache --upgrade git git-lfs rsync skopeo jq lynx binutils
# Node JS
RUN apk add --no-cache --upgrade nodejs npm yarn
# Python
RUN apk add --no-cache --upgrade python3 python3-dev py3-pip
# Dev tools
RUN apk add --no-cache --upgrade go gcc make cmake musl-dev gcompat libtool automake autoconf bison

# Docker
RUN apk add --no-cache --upgrade docker-cli docker-cli-buildx docker-cli-compose
RUN <<EOF
cd /usr/local/bin
for tool in $TOOLS_LIST; do
    wget -q $TOOLS_URL/$tool && chmod 755 $tool
done
EOF

# Additional tools
RUN apk add --no-cache --upgrade gawk grep sed procps util-linux iputils

ADD source /
RUN git config --global http.sslVerify false
