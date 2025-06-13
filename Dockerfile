FROM redhat/ubi9
COPY oc kubectl openshift-install /usr/local/bin
WORKDIR /root
