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
When creating a CentOS VM, no IP address is assigned to the Bridged Device. The host device is the wifi adapter.

Consequences:
- ssh not working
- internet not working

Solutions attempted:
* enable interface from within centos
```
ifup enp0s8
```

![error](/vagrant-and-vms/ifup_error.png) "ifup fails")



## Automatic setup of VMs on VirtualBox (using Vagrant)
Vagrant is a vm management tool

Basic vagrant commands:
```
vagrant init <boxname>
vagrant up
vagrant ssh
vagrant halt
vagrant destroy
```