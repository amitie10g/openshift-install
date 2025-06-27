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

### Add static IP address and hostname
#### Create the YAML ip.yaml
```
variant: fcos
version: 1.4.0
storage:
  files:
    - path: /etc/NetworkManager/system-connections/static-<interface>.nmconnection
      mode: 0600
      contents:
        inline: |
          [connection]
          id=static<interface>
          type=ethernet
          interface-name=<interface>

          [ipv4]
          method=manual
          address1=<ip>/<mask>,<gateway>
          dns=8.8.8.8;1.1.1.1;

          [ipv6]
          method=disabled
    - path: /etc/hostname
      mode: 0644
      contents:
        inline: <hostname>.<domain>
```
#### Build the ignition file with **butane**
    butane ip.yaml -o ip.ign

#### Append the contents of the ``files`` list into the ``bootstrap-in-place-for-live-iso`` file
**ip.ign**
```
{
    "ignition": {
        "version": "3.3.0"
    },
    "storage": {
        "files": [
            {
                "contents": {
                    "compression": "gzip",
                    "source": "data:;base64,<base64-encoded //etc/NetworkManager/system-connections/static-ens192.nmconnection"
                },
                "mode": 384,
                "path": "/etc/NetworkManager/system-connections/static-<interface>.nmconnection"
            },
            {
                "contents": {
                    "compression": "",
                    "source": "data:,<hostname>.<domain>"
                },
                "mode": 420,
                "path": "/etc/hostname"
            }
        ]
    }
}
```
**bootstrap-in-place-for-live-iso**
```
{
    "ignition": {
        "version": "3.3.0"
    },
    "passwd":{"users":[{"name":"core","sshAuthorizedKeys":["<ssh public key>","<other SSH key>"]}]},
    "storage": {
        "files": [
            {
                "contents": {
                    "compression": "gzip",
                    "source": "data:;base64,<base64-encoded //etc/NetworkManager/system-connections/static-ens192.nmconnection"
                },
                "mode": 384,
                "path": "/etc/NetworkManager/system-connections/static-<interface>.nmconnection"
            },
            {
                "contents": {
                    "compression": "",
                    "source": "data:,<hostname>.<domain>"
                },
                "mode": 420,
                "path": "/etc/hostname"
            },
                ...
            }
        }
    }
}
```


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
