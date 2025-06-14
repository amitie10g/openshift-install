ARG VERSION=4.19.0-okd-scos.3
ARG ARCH=x86_64

FROM quay.io/coreos/coreos-installer AS coreos
ARG VERSION

WORKDIR /tmp/openshift
RUN curl -LO https://github.com/okd-project/okd/releases/download/${VERSION}/openshift-client-linux-${VERSION}.tar.gz && \
    curl -LO https://github.com/okd-project/okd/releases/download/${VERSION}/openshift-install-linux-${VERSION}.tar.gz && \
    tar -xvf openshift-client-linux-${VERSION}.tar.gz && \
    tar -xvf openshift-install-linux-${VERSION}.tar.gz && \
    rm kubectl && \
    ln -s oc kubectl

FROM quay.io/fedora/fedora:42
ARG VERSION
ARG ARCH

RUN dnf install -y gpg kpartx lsblk udevadm && \
    dnf clean all

COPY --from=coreos /tmp/openshift/oc /tmp/openshift/kubectl /tmp/openshift/openshift-install /usr/bin/coreos-installer /usr/local/bin/

WORKDIR /root/okd

ENV VERSION=$VERSION
ENV ARCH=$ARCH
