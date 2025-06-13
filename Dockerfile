FROM redhat/ubi9

ARG VERSION=4.19.0-okd-scos.3

WORKDIR /tmp/openshift
RUN $ARCH=$(uname -m) && \
    [ "$ARCH" != "x86_64" ] && PLATFORM="-$ARCH" && \
    curl -LO https://github.com/okd-project/okd/releases/download/${VERSION}/openshift-client-linux${PLATFORM}-${VERSION}.tar.gz && \
    curl -LO https://github.com/okd-project/okd/releases/download/${VERSION}/openshift-install-linux${PLATFORM}-${VERSION}.tar.gz && \
    tar -xvf openshift-client-linux${PLATFORM}-${VERSION}.tar.gz && \
    tar -xvf openshift-client-linux${PLATFORM}-${VERSION}.tar.gz && \
    mv oc kubectl openshift-install /usr/local/bin && \
    rm -fr /tmp/openshift
