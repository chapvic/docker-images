ARG REGISTRY

FROM $REGISTRY/golang AS runner-builder
ARG RUNNER_SOURCE \
    RUNNER_VERSION=${RUNNER_VERSION}
# no branch - use latest commit
# RUN git clone -b v$RUNNER_VERSION $RUNNER_SOURCE act_runner
RUN git clone $RUNNER_SOURCE act_runner
ENV CGO_ENABLED=0 \
    CGO_CFLAGS="-DSQLITE_MAX_VARIABLE_NUMBER=32766" \
    LDFLAGS="-linkmode internal -extldflags=-s -extldflags=-static -X gitea.com/gitea/act_runner/internal/pkg/ver.version=${RUNNER_VERSION}"
WORKDIR /src/act_runner
RUN mkdir -p /app/bin
RUN go build -o /app/bin/act_runner -tags "netgo osusergo $TAGS" -ldflags "$LDFLAGS"


FROM $REGISTRY/alpine AS runner
ARG PUID=${PUID:-1000} \
    PGID=${PGID:-1000} \
    RUNNER_DATA=${RUNNER_DATA:-/data} \
    RUNNER_VERSION=${RUNNER_VERSION}
COPY --from=runner-builder /app /app
RUN <<EOF
set -e
apk add --no-cache acl
groupadd -g ${PGID} runner
useradd -u ${PUID} -g ${PGID} -d /app -s /bin/bash runner
mkdir -p $RUNNER_DATA
chown -R runner:runner $RUNNER_DATA
EOF
ADD source /
ENV PATH=/app/bin:$PATH \
    RUNNER_VERSION=$RUNNER_VERSION \
    RUNNER_DATA=$RUNNER_DATA
WORKDIR $RUNNER_DATA
HEALTHCHECK --interval=5s --timeout=3s CMD ["healthcheck"]
ENTRYPOINT ["entrypoint"]
