
## Setting up Ansible on a VM (control node)
Set up a new VM in the same network as the target VMs. Make sure SSH is installed and running on them

###For Ubuntu

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
    192.168.10.2 ansible_user=vagrant
    ```

    - test Ansible connectivity
    ```
    ansible all -m ping
    ```

    result:
    ![ping_pong](/ansible/ansible-ping-pong.jpg "success")


    ## Ansible Playbook to deploy Docker on a VM

