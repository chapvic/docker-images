# syntax=docker/dockerfile:1.8.1

ARG REGISTRY

FROM $REGISTRY/alpine AS powershell
ARG POWERSHELL_VERSION \
    POWERSHELL_URL \
    PUID=${PUID:-1000} \
    PGID=${PGID:-1000}
RUN apk add --no-cache --upgrade \
    less \
    ncurses-terminfo-base \
    krb5-libs \
    libgcc \
    libintl \
    libssl3 \
    libstdc++ \
    userspace-rcu \
    zlib \
    icu-libs
RUN apk -X https://dl-cdn.alpinelinux.org/alpine/edge/main add --no-cache --upgrade lttng-ust
### ------------------
### Install PowerShell
### ------------------
RUN <<EOF
wget -q --show-progress ${POWERSHELL_URL}/releases/download/v${POWERSHELL_VERSION}/powershell-${POWERSHELL_VERSION}-linux-musl-x64.tar.gz
mkdir -p /opt/powershell
tar xvf powershell-* -C /opt/powershell/
rm -f /powershell-*
chmod +x /opt/powershell/pwsh
ln -sf /opt/powershell/pwsh /usr/bin/pwsh
pwsh -Command Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
EOF
### -----------------------
### Install VMware-PowerCLI
### -----------------------
RUN <<EOF
pwsh -Command Install-Module VMware.PowerCLI -Scope AllUsers
pwsh -Command Set-PowerCLIConfiguration -Scope AllUsers -ParticipateInCeip:\$true -InvalidCertificateAction Ignore -DisplayDeprecationWarnings:\$false -Confirm:\$false
EOF
ADD source/profile.ps1 /root/.config/powershell/
ENV POWERSHELL_VERSION=$POWERSHELL_VERSION
ENTRYPOINT ["pwsh"]
