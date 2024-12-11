
## Setting up Ansible on a VM (control node)
Set up a new VM in the same network as the target VMs. Make sure SSH is installed and running on them

### For Ubuntu

1. **Install Ansible**
```
sudo apt update
sudo apt upgrade -y

sudo apt install -y ansible

ansible --version
```


2. **Set up SSH Keys**
- Generate an SSH Key Pair
    ```
    ssh-keygen -t rsa -b 4096
    ```

- Copy public keys to target VMs
    ```
    ssh-copy-id <username>@<vm ip addresse>

    #let's assue vagrant was used to create the VM, and given a random IP
    ssh-copy-id vagrant@192.168.10.2
    ```

- Test ssh connectivity
    ```
    ssh vagrant@192.168.10.2
    ```


3.  **Configure Ansible Inventory**
- create an inventory file
```
sudo vi /etc/ansible/hosts
```

- add the target VMs to the inventory
```
[vms]
192.168.10.2 ansible_user=vagrant
```

- test Ansible connectivity
```
ansible all -m ping
```

result:

![ping_pong](/ansible/ansible-ping-pong.jpg "success")


## Create Ansible Playbook to deploy Docker on a VM

- Create the playbook (e.g. install-docker.yml)
```
---
- name: Install Docker on VMs
  hosts: vms
  become: true

  tasks:
    - name: Install dependencies
      apt:
        name:
          - apt-transport-https
          - ca-certificates
          - curl
          - software-properties-common
        state: present
      when: ansible_distribution == "Ubuntu"

    - name: Install Docker
      apt:
        name: docker.io
        state: present
      when: ansible_distribution == "Ubuntu"

    - name: Start and enable Docker
      service:
        name: docker
        state: started
        enabled: true
```

- Run the playbook
In this case it is assumed the command is ran on the same directory of the file.
```
ansible-playbook install-docker.yml
```
![docker install](/ansible/ansible-docker-install.jpg)

- Verify docker installation on the target VM
```
ssh vagrant@192.168.10.2
docker --version
sudo systemctl status docker
```