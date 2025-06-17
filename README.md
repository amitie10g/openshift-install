# openshift-install
Tools for provisioning OpenShift and OKD, dockerized

## Tools included
* openshift-install
* kubectl
* oc
* butane (for handling YAML to JSON ignition)
* coreos-installer (for handling ISO images)

## Usage
    docker run -it -v $(pwd):/root/openshift openshift-install
