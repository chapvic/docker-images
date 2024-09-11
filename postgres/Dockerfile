# syntax=docker/dockerfile:1.8.1

ARG REGISTRY

FROM $REGISTRY/alpine-dev AS postgres-builder
ARG POSTGRES_SOURCE \
    POSTGRES_TAG \
    PG_VECTOR_VERSION \
    PG_VECTOR_SOURCE \
    LLVM_VERSION=${LLVM_VERSION:-15} \
    CLANG_VERSION=${CLANG_VERSION:-15}
ENV LLVM_CONFIG="/usr/lib/llvm${LLVM_VERSION}/bin/llvm-config" \
    CLANG=clang-${CLANG_VERSION}
RUN apk add --no-cache --upgrade \
    flex-dev perl-dev musl-libintl musl-locales gettext-tiny zstd-dev readline-static python3-dev tcl-dev krb5-dev \
    perl-locale-msgfmt perl-dev perl-ipc-run perl-utils e2fsprogs-dev openldap-dev openldap-back-mdb openldap-overlay-all \
    llvm${LLVM_VERSION}-dev clang${CLANG_VERSION}
RUN git clone -b $POSTGRES_TAG $POSTGRES_SOURCE postgres
WORKDIR /src/postgres
RUN ../postgres/configure \
    --prefix=/app \
    --enable-nls='en ru' \
    --enable-integer-datetimes \
    --enable-thread-safety \
    --enable-tap-tests \
    --disable-rpath \
    --with-uuid=e2fs \
    --with-gnu-ld \
    --with-pgport=5432 \
    --with-system-tzdata=/usr/share/zoneinfo \
    --with-gssapi \
    --with-ldap \
    --with-tcl \
    --with-perl \
    --with-python \
    --with-openssl \
    --with-libintl \
    --with-libxml \
    --with-libxslt \
    --with-icu \
    --with-tcl \
    --with-llvm \
    --with-lz4 \
    --with-llvm \
    --with-zstd
ENV CFLAGS='-O2 -pipe'
RUN make -j$(nproc) world-bin
RUN make install-world-bin
RUN make -j$(nproc) -C contrib install


FROM $REGISTRY/alpine AS postgres
ARG POSTGRES_VERSION \
    LLVM_VERSION=${LLVM_VERSION:-15} \
    CLANG_VERSION=${CLANG_VERSION:-15} \
    PUID ${PUID:-1000} \
    PGID ${PGID:-1000}
RUN apk add --no-cache --upgrade lz4 lz4-libs zstd libxml2 libxslt musl-libintl musl-locales e2fsprogs-libs \
    libuuid tcl icu-libs icu-data-full krb5-libs openldap openldap-back-mdb openldap-overlay-all \
    llvm${LLVM_VERSION}-libs clang${CLANG_VERSION}-libs clang${CLANG_VERSION}-libclang
COPY --from=postgres-builder /app /app
ADD source /
ENV PATH=/app/bin:$PATH \
    PGDATA=/data \
    POSTGRES_VERSION=$POSTGRES_VERSION
RUN groupadd -g $PGID postgres && \
    useradd -g $PGID -u $PUID -d /home/postgres -s /bin/bash -m postgres && \
    cp -rf /root/.bashrc /root/.config /home/postgres/ && \
    chown -R postgres:postgres /home/postgres && \
    mkdir -p $PGDATA && \
    chown postgres:root $PGDATA && \
    chmod 700 $PGDATA && \
    echo '/app/lib:/app/lib/postgresql:/lib:/usr/lib:/usr/local/lib' > /etc/ld-musl-x86_64.path
STOPSIGNAL SIGINT
EXPOSE 5432
HEALTHCHECK --interval=5s --timeout=3s CMD ["healthcheck"]
ENTRYPOINT ["entrypoint"]
