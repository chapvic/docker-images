ARG REGISTRY


FROM $REGISTRY/alpine-dev AS keycloak-builder
ARG KEYCLOAK_VERSION \
    KEYCLOAK_SOURCE \
    JDK_VERSION
RUN apk add --no-cache --upgrade openjdk${JDK_VERSION}-static-libs maven jq grep
ADD ${KEYCLOAK_SOURCE}/archive/refs/tags/${KEYCLOAK_VERSION}.tar.gz ./
RUN tar xzf ${KEYCLOAK_VERSION}.tar.gz
WORKDIR /src/keycloak-${KEYCLOAK_VERSION}/quarkus
RUN ../mvnw clean install -Pdistribution -DskipTests=true
RUN mkdir /app && tar -xzvf dist/target/keycloak-${KEYCLOAK_VERSION}.tar.gz -C /app --strip=1


FROM $REGISTRY/alpine
ARG KEYCLOAK_VERSION \
    JDK_VERSION \
    PUID=${PUID:-1000} \
    PGID=${PUID:-1000}
RUN apk add --no-cache --upgrade openjdk${JDK_VERSION}-jre-headless
COPY --from=keycloak-builder /app /app
RUN groupadd -g ${PGID} keycloak && \
    useradd -u ${PUID} -g ${PGID} -d /app -s /bin/bash keycloak && \
    chown -R keycloak:keycloak /app
ADD source /
ENV KEYCLOAK_VERSION=${KEYCLOAK_VERSION} \
    LANG=${LANG}
EXPOSE 8080/tcp 8443/tcp
HEALTHCHECK --interval=5s --timeout=3s CMD ["healthcheck"]
ENTRYPOINT ["entrypoint"]
