ARG REGISTRY

FROM $REGISTRY/alt AS pgpro-alt
ARG PGPRO_VERSION \
    PGPRO_REPO_URL \
    PGPRO_RELEASE \
    PUID=${PUID:-1000} \
    PGID=${PGID:-1000}
ENV PGDATA=/data/std-${PGPRO_VERSION} \
    PGPRO_VERSION=${PGPRO_VERSION}
RUN <<EOF
set -e
apt-get update && apt-get -y dist-upgrade
curl ${PGPRO_REPO_URL}/${PGPRO_RELEASE}/${PGPRO_RELEASE}-${PGPRO_VERSION}/keys/pgpro-repo-add.sh | bash -
apt-get -y install postgrespro-std-${PGPRO_VERSION}-contrib
apt-get clean
echo "export PATH=/opt/pgpro/std-${PGPRO_VERSION}/bin:\$PATH" >> /root/.bashrc
userdel -rf postgres
groupadd -g $PGID postgres
useradd -g $PGID -u $PUID -d /home/postgres -s /bin/bash -m postgres
cp -rf /root/.bashrc /root/.config /home/postgres/
chown -R postgres:postgres /home/postgres
mkdir -p $PGDATA && chown postgres:root $PGDATA && chmod 700 $PGDATA
EOF
ADD source/all /
STOPSIGNAL SIGINT
EXPOSE 5432
HEALTHCHECK --interval=5s --timeout=3s CMD ["healthcheck"]
ENTRYPOINT ["entrypoint"]


FROM $REGISTRY/debian:12 AS pgpro-debian
ARG PGPRO_VERSION \
    PGPRO_REPO_URL \
    PGPRO_RELEASE \
    LANG \
    TZ \
    PUID=${PUID:-1000} \
    PGID=${PGID:-1000}
ENV PGDATA=/data/std-${PGPRO_VERSION} \
    PGPRO_VERSION=${PGPRO_VERSION} \
    SHELL=/bin/bash \
    LANG=$LANG \
    LC=$LANG \
    TZ=$TZ \
    DEBIAN_FRONTEND=noninteractive
ADD source/all source/debian /
RUN <<EOF
set -e
apt-get update && apt-get -y dist-upgrade && apt-get -y install curl iproute2
curl ${PGPRO_REPO_URL}/${PGPRO_RELEASE}/${PGPRO_RELEASE}-${PGPRO_VERSION}/keys/pgpro-repo-add.sh | bash -
apt-get -y install postgrespro-std-${PGPRO_VERSION}-contrib
apt-get clean
userdel -rf postgres
groupadd -g $PGID postgres
useradd -g $PGID -u $PUID -d /home/postgres -s /bin/bash -m postgres
cp -rf /root/.profile /root/.bashrc /home/postgres/
chown -R postgres:postgres /home/postgres
mkdir -p $PGDATA && chown postgres:root $PGDATA && chmod 700 $PGDATA
EOF
ENV PATH=/opt/pgpro/std-${PGPRO_VERSION}/bin:$PATH \
    CL_NONE="\e[0;0m" \
    CL_GRAY="\e[3;0m" \
    CL_DARK_RED="\e[0;31m" \
    CL_RED="\e[1;31m" \
    CL_DARK_GREEN="\e[0;32m" \
    CL_GREEN="\e[1;32m" \
    CL_DARK_YELLOW="\e[0;33m" \
    CL_YELLOW="\e[1;33m" \
    CL_DARK_BLUE="\e[0;34m" \
    CL_BLUE="\e[1;34m" \
    CL_DARK_MAGENTA="\e[0;35m" \
    CL_MAGENTA="\e[1;35m" \
    CL_DARK_CYAN="\e[0;36m" \
    CL_CYAN="\e[1;36m" \
    CL_WHITE="\e[1;37m"
STOPSIGNAL SIGINT
EXPOSE 5432
HEALTHCHECK --interval=5s --timeout=3s CMD ["healthcheck"]
ENTRYPOINT ["entrypoint"]
