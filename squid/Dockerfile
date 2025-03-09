# syntax=docker/dockerfile:1.8.1

ARG REGISTRY

FROM $REGISTRY/alpine-dev AS squid-builder
ARG SQUID_SOURCE \
    SQUID_TAG \
    SQUID_ROOT \
    SQUID_CONFDIR \
    SQUID_LOGDIR \
    SQUID_OPT_WITH \
    SQUID_OPT_ENABLE \
    SQUID_OPT_DISABLE \
    SQUID_BUILD_INFO
RUN apk -X https://dl-cdn.alpinelinux.org/alpine/edge/testing add --no-cache libecap-dev && \
    apk add --no-cache --upgrade build-base automake autoconf libtool wget ed krb5-dev openssl-dev libxml2-dev libcap-dev expat-dev openldap-dev \
    libnetfilter_conntrack-dev libgss-dev libaio-dev nettle-dev libcap-dev libltdl zlib-dev icu-dev xz-dev iputils-ping
RUN git clone -b ${SQUID_TAG} ${SQUID_SOURCE} squid
WORKDIR /src/squid
#ADD patch/src ./src
#RUN patch -d ./src -t client_side_request.cc -i client_side_request.cc.patch
RUN ./bootstrap.sh
RUN ./configure --prefix=$SQUID_ROOT --sysconfdir=$SQUID_CONFDIR --with-logdir=$SQUID_LOGDIR --with-default-user=squid \
    $SQUID_OPT_WITH $SQUID_OPT_ENABLE $SQUID_OPT_DISABLE --enable-build-info="$SQUID_BUILD_INFO" CXXFLAGS='-w'
RUN make -j$(nproc --all) && make install


FROM $REGISTRY/alpine AS squid
ARG SQUID_VERSION \
    SQUID_ROOT \
    SQUID_CONFDIR \
    SQUID_CONFDIR_DEFAULT \
    SQUID_LOGDIR \
    PUID=${PUID:-1000} \
    PGID=${PGID:-1000}
ENV SHELL=/bin/bash \
    PATH=$SQUID_ROOT/bin:$SQUID_ROOT/sbin:$PATH
COPY --from=squid-builder $SQUID_ROOT $SQUID_ROOT
RUN apk -X https://dl-cdn.alpinelinux.org/alpine/edge/testing add --no-cache libecap && \
     userdel -rf squid &>/dev/null || echo '' ; \
    apk add --no-cache --upgrade mc bash shadow wget openssl openldap-clients krb5 krb5-libs libcap2 libxml2 icu-libs icu-data-full \
        libexpat libnetfilter_conntrack libgss libaio nettle libltdl xz-libs iputils-ping && \
    mkdir -p $SQUID_CONFDIR_DEFAULT && \
    mv -f $SQUID_CONFDIR/*.default $SQUID_CONFDIR_DEFAULT/ && \
    mv -f $SQUID_CONFDIR/*.documented $SQUID_CONFDIR_DEFAULT/ && \
    groupadd -g $PGID squid && \
    useradd -g squid -u $PUID -s /sbin/nologin -d $SQUID_ROOT/var/cache/squid squid && \
    chown -R squid:squid $SQUID_ROOT && \
    echo -e "# Setup Squid Environment\n\
    SQUID_VERSION=$SQUID_VERSION\n\
    SQUID_ROOT=$SQUID_ROOT\n\
    SQUID_CONFDIR=$SQUID_CONFDIR\n\
    SQUID_CONFDIR_DEFAULT=$SQUID_CONFDIR_DEFAULT\n\
    SQUID_LOGDIR=$SQUID_LOGDIR" > /etc/squid.env
ADD source /
STOPSIGNAL SIGINT
HEALTHCHECK --interval=5s --timeout=3s CMD ["healthcheck"]
ENTRYPOINT ["entrypoint"]
