ARG REGISTRY

FROM $REGISTRY/alpine-dev AS nginx-builder
ARG NGINX_VERSION \
    NGINX_SOURCE \
    GEOIP2_VERSION \
    GEOIP2_SOURCE
RUN apk add --update --no-cache gd-dev geoip-dev libatomic_ops-dev zlib-static perl-dev libmaxminddb-dev
RUN git clone -b $GEOIP2_VERSION $GEOIP2_SOURCE geoip2
RUN git clone -b release-$NGINX_VERSION $NGINX_SOURCE nginx
WORKDIR /src/nginx
RUN ./auto/configure --prefix=/app \
--user=nginx \
--group=nginx \
--sbin-path=/app/bin/nginx \
--conf-path=/app/etc/nginx.conf \
--error-log-path=/app/var/logs/error.log \
--pid-path=/app/var/run/nginx.pid \
--lock-path=/app/var/run/nginx.lock \
--modules-path=/app/modules \
--http-log-path=/app/var/logs/access.log \
--http-client-body-temp-path=/app/var/tmp/client_body \
--http-proxy-temp-path=/app/var/tmp/proxy \
--http-fastcgi-temp-path=/app/var/tmp/fastcgi \
--http-uwsgi-temp-path=/app/var/tmp/uwcgi \
--http-scgi-temp-path=/app/var/tmp/scgi \
--with-select_module \
--with-poll_module \
--with-threads \
--with-file-aio \
--with-http_ssl_module \
--with-http_v2_module \
--with-http_v3_module \
--with-http_realip_module \
--with-http_addition_module \
--with-http_xslt_module=dynamic \
--with-http_image_filter_module=dynamic \
--with-http_geoip_module=dynamic \
--with-http_sub_module \
--with-http_dav_module \
--with-http_flv_module \
--with-http_mp4_module \
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_auth_request_module \
--with-http_random_index_module \
--with-http_secure_link_module \
--with-http_degradation_module \
--with-http_slice_module \
--with-http_stub_status_module \
--with-http_perl_module=dynamic \
--with-perl_modules_path=/app/modules/perl \
--with-mail=dynamic \
--with-mail_ssl_module \
--with-stream=dynamic \
--with-stream_ssl_module \
--with-stream_realip_module \
--with-stream_geoip_module=dynamic \
--with-stream_ssl_preread_module \
--with-cpp_test_module \
--with-compat \
--with-pcre \
--with-pcre-jit \
--with-libatomic \
--add-dynamic-module=/src/geoip2
RUN make -j$(nproc) && make install
RUN mkdir -p /app/var/logs /app/var/run /app/var/tmp /app/var/dist /app/var/startup
RUN mv /app/etc/*.default /app/var/dist/


FROM $REGISTRY/alpine AS nginx
ARG NGINX_VERSION \
    PUID=${PUID:-1000} \
    PGID=${PGID:-1000}
COPY --from=nginx-builder /app /app
RUN <<EOF
set -e
apk add --update --no-cache gd geoip libatomic_ops libmaxminddb
groupadd -g $PGID nginx
useradd -u $PUID -g $PGID -d /app/html -s /sbin/nologin -m nginx
chown -R nginx:nginx /app
EOF
ADD source /
ENV PATH=/app/bin:$PATH \
    NGINX_VERSION=$NGINX_VERSION
STOPSIGNAL SIGINT
EXPOSE 80/tcp 443/tcp
HEALTHCHECK --interval=5s --timeout=3s CMD ["healthcheck"]
ENTRYPOINT ["entrypoint"]
