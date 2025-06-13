FROM redhat/ubi9

ARG VERSION=4.19.0-okd-scos.3
ARG PLATFORM

WORKDIR /tmp/openshift
RUN set x && echo $PLATFORM
