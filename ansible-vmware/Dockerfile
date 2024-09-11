# syntax=docker/dockerfile:1.8.1

ARG REGISTRY \
    OS_VERSION

FROM $REGISTRY/$OS_VERSION AS ansible-builder
ARG ANSIBLE_VERSION \
    TZ
RUN ln -sf /usr/share/zoneinfo/$TZ /etc/localtime && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y bash bash-completion git-core wget pip python3 python3-pip && \
    apt-get autoremove -y && \
    apt-get clean && \
    pip install \
    jinja2 \
    resolvelib \
    PyYAML
RUN wget https://github.com/ansible/ansible/archive/refs/tags/v${ANSIBLE_VERSION}.tar.gz && \
    tar xzf v${ANSIBLE_VERSION}.tar.gz && \
    cd ansible-${ANSIBLE_VERSION} && \
    python3 setup.py install && \
    cd .. && \
    rm -rf ansible-${ANSIBLE_VERSION} && \
    rm -f v${ANSIBLE_VERSION}.tar.gz && \
    pip install jmespath pyvmomi pyVim requests && \
    ansible-galaxy collection install community.general


FROM ansible-builder AS ansible-vmware
ARG VMWARE_PLUGIN_VERSION
RUN ansible-galaxy collection install community.vmware:${VMWARE_PLUGIN_VERSION}
