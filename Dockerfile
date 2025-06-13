FROM quay.io/fedora/fedora:42 AS base
ARG VERSION=4.19.0-okd-scos.3
WORKDIR /tmp/openshift
RUN curl -LO https://github.com/okd-project/okd/releases/download/${VERSION}/openshift-client-linux-${VERSION}.tar.gz && \
    curl -LO https://github.com/okd-project/okd/releases/download/${VERSION}/openshift-install-linux-${VERSION}.tar.gz && \
    tar -xvf openshift-client-linux-${VERSION}.tar.gz && \
    tar -xvf openshift-install-linux-${VERSION}.tar.gz && \
    mv oc kubectl openshift-install /usr/local/bin && \
    rm -fr /tmp/openshift
RUN dnf install -y gpg kpartx lsblk udevadm && \
    dnf clean all
COPY --from=quay.io/coreos/coreos-installer /usr/local/bin/coreos-installer /usr/local/bin/coreos-installer
WORKDIR /root
