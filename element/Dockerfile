# syntax=docker/dockerfile:1.8.1

ARG REGISTRY

FROM $REGISTRY/alpine-dev AS element-builder
ARG ELEMENT_VERSION \
    ELEMENT_SOURCE \
    USE_CUSTOM_SDKS \
    REACT_SDK_REPO \
    REACT_SDK_BRANCH \
    JS_SDK_REPO \
    JS_SDK_BRANCH
ENV DIST_VERSION=$ELEMENT_VERSION
RUN git clone -b v${ELEMENT_VERSION} ${ELEMENT_SOURCE} element
WORKDIR /src/element
RUN yarn install
RUN scripts/package.sh


FROM $REGISTRY/alpine AS element
ARG ELEMENT_VERSION \
    PUID ${PUID:-1000} \
    PGID ${PGID:-1000}
RUN apk add --no-cache --upgrade nginx
COPY --from=element-builder /src/element/webapp /app
COPY --from=element-builder /src/element/nginx/conf.d/default.conf /etc/nginx/http.d/default.conf
ADD source /
RUN <<EOF
set -e
groupmod -g $PGID -n matrix nginx
usermod -u $PUID -l matrix nginx
rm -rf /usr/share/nginx/html
ln -s /app /usr/share/nginx/html
sed -i 's/user nginx/user matrix/' /etc/nginx/nginx.conf
chown -R matrix:matrix /app /etc/nginx /var/lib/nginx /var/log/nginx /run/nginx
EOF
ENV ELEMENT_VERSION=$ELEMENT_VERSION
STOPSIGNAL SIGINT
HEALTHCHECK --interval=5s --timeout=3s CMD ["healthcheck"]
ENTRYPOINT ["entrypoint"]
