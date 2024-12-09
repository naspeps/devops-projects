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


## Connnectivity between VMs in a cluster or network
**Troubleshooting ssh**

While trying to establish ssh from one VM to another VM, a possible error is the below:
```
vagrant@ansiblevm:~$ ssh vagrant@192.168.10.4
vagrant@192.168.10.4: Permission denied (publickey)
```

A solution: 

- Copy the public key to the other VM
    - ssh into VM1
    - copy the keys
    ```
    ssh-copy-id -i ~/.ssh/id_rsa.pub user@VM2
    ```

- Manually copy the key (if ssh_copy-id isn't available)
    - Get VM1's public key
    ```
    cat ~/.ssh/id_rsa.pub
    ```

    - On VM2
    ```
    echo "PASTE_PUBLIC_KEY_HERE" >> ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys
    ```

    - Ensure SSH on VM2 accepts keys
    edit /etc/ssh/sshd_config
    ```
    PubkeyAuthentication yes
    AuthorizedKeysFile .ssh/authorized_keys
    ```

    - Restart ssh service
    ```
    sudo systemctl restart sshd
    ```
Now test ssh from VM1 to VM2


