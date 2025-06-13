FROM redhat/ubi9

VERSION=4.19.0-okd-scos.3
RUN curl -LO https://github.com/okd-project/okd/releases/download/${VERSION}/openshift-client-linux-${VERSION}.tar.gz && \
    curl -LO https://github.com/okd-project/okd/releases/download/${VERSION}/openshift-install-linux-${VERSION}.tar.gz && \
    tar -xvf *.tar.gz
    mv oc kubectl openshift-install /usr/local/bin
