# openshift-install
Tools for provisioning OpenShift and OKD, dockerized

## Tools included
* openshift-install
* kubectl
* oc
* butane (for handling YAML to JSON ignition)
* coreos-installer (for handling ISO images)

## Usage
### Interactive shell
    docker run -it -v $(pwd):/root/openshift ghcr.io/amitie10g/openshift-install

### Download ISO
    curl -L $(openshift-install coreos print-stream-json | grep location | grep $ARCH | grep iso | cut -d\" -f4) -o fcos-live-$VERSION.iso

### Create ignition
    openshift-install create single-node-ignition-config

### Write ignition and set fixed IP address as kernel parameters 
* replace the destination device and addressing as your needs!
* You may need to identify the name of the interface using vanilla RHCOS, SCOS or FCOS disc image without installing anything
* IPv6 is disabled. Enable only if you need it
```
coreos-installer iso customize \
    --dest-ignition bootstrap-in-place-for-live-iso.ign \
    --live-ignition bootstrap-in-place-for-live-iso.ign \
    --dest-device "/dev/<destination block device>" \
    --dest-karg-append "ipv6.disable=1" \
    --dest-karg-append "ip=<IP address>::<Gateway>:<Subnet mask>:<hostname.domain>:<device to be set>:none" \+
    --dest-karg-append "nameserver=1.1.1.1" \
    --dest-karg-append "nameserver=8.8.8.8" \
    --dest-karg-append "hostname=<hostname>.<domain>" \
    --live-karg-append "ipv6.disable=1" \
    --live-karg-append "ip=<IP address>::<Gateway>:<Subnet mask>:<hostname.domain>:<device to be set>:none" \
    --live-karg-append "nameserver=1.1.1.1" \
    --live-karg-append "nameserver=8.8.8.8" \
    --live-karg-append "hostname=<hostname>.<domain>" \
    --output fcos-live-custom.iso \
    fcos-live-$VERSION.iso
```
* You will get ``fcos-live-custom.iso``. Use it for provisioning your SNO cluster.

## Update /etc/hosts
Uppon first reboot (early!!!), append the following to the /etc/hosts file:
```
127.0.0.1 api.<domain>
127.0.0.1 api-int.<domain>
127.0.0.1 oauth-openshift.apps.<domain>
127.0.0.1 console-openshift-console.apps.<domain>
127.0.0.1 downloads-openshift-console.apps.<domain>
127.0.0.1 canary-openshift-ingress-canary.apps.<domain>
127.0.0.1 alertmanager-main-openshift-monitoring.apps.<domain>
127.0.0.1 prometheus-k8s-openshift-monitoring.apps.<domain>
127.0.0.1 prometheus-k8s-federate-openshift-monitoring.apps.<domain>
127.0.0.1 thanos-querier-openshift-monitoring.apps.<domain>

<node_ip> api.<domain>
<node_ip> api-int.<domain>
<node_ip> oauth-openshift.apps.<domain>
<node_ip> console-openshift-console.apps.<domain>
<node_ip> downloads-openshift-console.apps.<domain>
<node_ip> canary-openshift-ingress-canary.apps.<domain>
<node_ip> alertmanager-main-openshift-monitoring.apps.<domain>
<node_ip> prometheus-k8s-openshift-monitoring.apps.<domain>
<node_ip> prometheus-k8s-federate-openshift-monitoring.apps.<domain>
<node_ip> thanos-querier-openshift-monitoring.apps.<domain>
```

## Tested with:
* **OKD 4.20**: fail
* **OKD 4.19**: fail
* **OKD 4.1**8: fail
* **OKD 4.15**: testing
  *** Upgrade to 4.20**: pending 
