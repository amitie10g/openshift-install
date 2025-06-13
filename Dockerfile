FROM quay.io/fedora/fedora:42 AS builder
RUN dnf install -y cargo git-core libzstd-devel openssl-devel xz-devel
WORKDIR /build
COPY Cargo.* ./
COPY src src/
# Debug symbols are nice but they're not 100+ MB of nice
RUN sed -i 's/^debug = true$/debug = false/' Cargo.toml
# aarch64 release builds running in emulation take too long and time out the
# GitHub Action.  Disable optimization.
RUN if [ $(uname -p) != x86_64 ]; then sed -i "s/^debug = false$/debug = false\nopt-level = 0/" Cargo.toml; fi
# Avoid OOM on emulated arm64
# https://github.com/rust-lang/cargo/issues/10583
RUN mkdir -p .cargo && echo -e '[net]\ngit-fetch-with-cli = true' > .cargo/config.toml
RUN cargo build --release

FROM quay.io/fedora/fedora:42 AS base
ARG VERSION=4.19.0-okd-scos.3
WORKDIR /tmp/openshift
RUN curl -LO https://github.com/okd-project/okd/releases/download/${VERSION}/openshift-client-linux-${VERSION}.tar.gz && \
    curl -LO https://github.com/okd-project/okd/releases/download/${VERSION}/openshift-install-linux-${VERSION}.tar.gz && \
    tar -xvf openshift-client-linux${PLATFORM}-${VERSION}.tar.gz && \
    tar -xvf openshift-install-linux${PLATFORM}-${VERSION}.tar.gz && \
    mv oc kubectl openshift-install /usr/local/bin && \
    rm -fr /tmp/openshift
WORKDIR /root

FROM quay.io/fedora/fedora:42 AS installer
RUN dnf install -y /usr/bin/gpg /usr/bin/kpartx /usr/bin/lsblk \
    /usr/bin/udevadm && \
    dnf clean all
COPY --from=builder /build/target/release/coreos-installer /usr/local/bin
