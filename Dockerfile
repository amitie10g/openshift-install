FROM quay.io/coreos/coreos-installer
ARG  OKD_VERSION=4.19.0-okd-scos.3
ARG  ARCH=x86_64

WORKDIR /tmp/openshift
RUN curl -LO https://github.com/okd-project/okd/releases/download/${OKD_VERSION}/openshift-client-linux-${OKD_VERSION}.tar.gz && \
    curl -LO https://github.com/okd-project/okd/releases/download/${OKD_VERSION}/openshift-install-linux-${OKD_VERSION}.tar.gz && \
    tar -xvf openshift-client-linux-${VERSION}.tar.gz && \
    tar -xvf openshift-install-linux-${VERSION}.tar.gz && \
    mv oc kubectl openshift-install /usr/local/bin && \
    rm -fr /tmp/openshift

RUN dnf install -y gpg kpartx lsblk udevadm && \
    dnf clean all

ENV OKD_VERSION=${OKD_VERSION}
ENV ARCH=${ARCH}

WORKDIR /root/okd
