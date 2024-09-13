# syntax=docker/dockerfile:1.8.1

ARG REGISTRY \
    POSTGRES_VERSION

FROM $REGISTRY/postgres:${POSTGRES_VERSION} AS postgres-app

FROM $REGISTRY/rust AS pgvectors-builder
ARG ARCH \
    POSTGRES_VERSION \
    PGVECTORS_VERSION \
    PGVECTORS_SOURCE \
    LLVM_VERSION=${LLVM_VERSION:-16} \
    CLANG_VERSION=${CLANG_VERSION:-16} \
    PUID ${PUID:-1000} \
    PGID ${PGID:-1000}
ENV RUSTFLAGS=-Ctarget-feature=-crt-static \
    CLANG=clang-${CLANG_VERSION} \
    LLVM_CONFIG="/usr/lib/llvm${LLVM_VERSION}/bin/llvm_config"
RUN apk add --no-cache clang${CLANG_VERSION}-dev clang${CLANG_VERSION}-static \
    llvm${LLVM_VERSION}-dev llvm${LLVM_VERSION}-static lld \
    lz4 lz4-libs zstd libxml2 libxslt musl-libintl musl-locales e2fsprogs-libs \
    libuuid tcl icu-libs icu-data-full krb5-libs openldap openldap-back-mdb openldap-overlay-all && \
    groupadd -g $PGID postgres && \
    useradd -g $PGID -u $PUID -d /home/postgres -s /bin/bash -m postgres && \
    git clone -b v$PGVECTORS_VERSION $PGVECTORS_SOURCE /src && \
    sed -i 's/^version =.*/version = "'$PGVECTORS_VERSION'"/' Cargo.toml && \
    sed -i 's/@CARGO_VERSION@/'${PGVECTORS_VERSION}'/' vectors.control
ENV PGDATA=/data \
    POSTGRES_VERSION=$POSTGRES_VERSION \
    PATH=/app/bin:$PATH
COPY --from=postgres-app /app /app
COPY --from=postgres-app /usr/local/bin /usr/local/bin
RUN echo '/app/lib:/app/lib/postgresql:/lib:/usr/lib:/usr/local/lib' > /etc/ld-musl-$ARCH.path && init-db
RUN cargo install cargo-pgrx@$(grep 'pgrx = {' Cargo.toml | cut -d '"' -f 2 | head -n 1)
RUN cargo pgrx init --pg${POSTGRES_VERSION} /app/bin/pg_config
RUN cargo pgrx install -r -v -c /app/bin/pg_config
RUN mkdir -p /release/lib/postgresql /release/share/postgresql/extension && \
    cp /app/lib/postgresql/vectors.so /release/lib/postgresql/ && \
    cp /src/sql/install/vectors--${PGVECTORS_VERSION}.sql /release/share/postgresql/extension/ && \
    cp /src/sql/upgrade/*.sql /release/share/postgresql/extension/ && \
    cp /src/vectors.control /release/share/postgresql/extension/

# --------------------------------------------------------------------------------------------------
# Building result:
#
# /app/lib/postgresql/vectors.so
# /app/share/postgresql/extension/vectors.control
# /app/share/postgresql/extension/vectors--***.sql
#
# POSTGRES_OPTIONS='-c shared_preload_libraries=vectors.so -c search_path=\"\$user\",public,vectors'
# --------------------------------------------------------------------------------------------------

FROM postgres-app
COPY --from=pgvectors-builder /release /app
ENV POSTGRES_OPTIONS='-c shared_preload_libraries=vectors.so -c search_path=\"\$user\",public,vectors'
