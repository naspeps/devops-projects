## Prerequisites 
Install chocolately to ease software installation

Install Virtual box
```
choco install virtualbox --version=7.0.8 -y
```

Install Vagrant 
```
choco install vagrant --version=2.3.7 -y
```

## Manual setup of VMs on VirtualBox
**Troubleshooting network**
When creating a CentOS/Ubuntu VM, no IP address is assigned to the Bridged Device. The host device is the wifi adapter.

Error example during ubuntu installation
![ubuntu error](/vagrant-and-vms/ubuntu_shared_adapter_fail.png "bridged adapter fail")

Consequences:
- ssh not working
- internet not working

Solutions attempted:
* enable interface from within centos
```
ifup enp0s8
```

![error](/vagrant-and-vms/ifup_error.png "ifup fails")



## Automatic setup of VMs on VirtualBox (using Vagrant)
Vagrant is a vm management tool

Basic vagrant commands:
```
vagrant init <boxname>
vagrant up
vagrant ssh
vagrant halt
vagrant status
vagrant destroy
vagrant box list
```

More commands:
```
#status of all vms
vagrant global-status
```

## Automatic deployment of a vm cluster
Using vagrant, 3 vms are to be deployed and they should be able to communicate with each other (ping, ssh)

- create a (private) network and assign ips to the vms

Remarks:
- Ping only works on the ip addresses and not hostname.
    - The VirtualBox private network (or host-only network) doesn't include a DNS server to resolve hostnames.