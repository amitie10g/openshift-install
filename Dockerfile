FROM redhat/ubi9
COPY oc kubectl openshift-installer /usr/local/bin
WORKDIR /root
