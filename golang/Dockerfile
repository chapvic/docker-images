ARG REGISTRY

FROM $REGISTRY/alpine-dev AS golang-builder
ARG GOLANG_SOURCE \
    GOLANG_VERSION
RUN <<EOF
set -e
cd /opt
wget -O golang.tar.gz ${GOLANG_SOURCE}
tar xzvf golang.tar.gz
rm -f golang.tar.gz
EOF
ENV PATH=/opt/go/bin:$PATH \
    GOBIN=/opt/go/bin \
    GOPATH=/src \
    GOLANG_VERSION=$GOLANG_VERSION
WORKDIR /src
CMD ["bash"]
