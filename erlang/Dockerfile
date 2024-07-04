ARG REGISTRY

FROM $REGISTRY/alpine:latest AS erlang-builder
ARG ERLANG_TAG \
    ERLANG_SOURCE \
    ERLANG_VERSION \
    REBAR3_SOURCE \
    REBAR3_VERSION
WORKDIR /src
RUN apk add --no-cache --upgrade gcc g++ make autoconf libtool ncurses-dev openssl-dev openjdk21 libc-dev unixodbc-dev wxwidgets-dev
# RUN git clone -b maint-$ERLANG_VERSION $ERLANG_SOURCE
RUN git clone -b $ERLANG_TAG $ERLANG_SOURCE otp
RUN git clone -b $REBAR3_VERSION $REBAR3_SOURCE rebar3
RUN cd /src/otp && ./configure && make -j$(nproc) && make install
RUN cd /src/rebar3 && ./bootstrap && ./rebar3 local install

FROM $REGISTRY/alpine:latest
RUN apk add --no-cache --upgrade ncurses musl openssl openjdk21-jre unixodbc wxwidgets wxwidgets-webview
COPY --from=erlang-builder /usr/local /usr/local
COPY --from=erlang-builder /root/.cache /root/.cache
WORKDIR /src
CMD ["erl"]
