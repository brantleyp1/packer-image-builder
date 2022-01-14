# CIS-Ubuntu-20.04-ansible

Borrowed very librally from alivx's [GitHub](https://github.com/alivx/CIS-Ubuntu-20.04-Ansible) role. Original README from that repo is saved as OLD-README.md.

CIS based hardening role for defining a security baseline on Ubuntu 20.04.

## Details

See the above GitHub for more detail on the steps, there are many tasks ran at many levels to establish the baseline.

## Gotchas

There are several options that can result in you being locked out of a system if you're not careful. This role, as it stands, only allows root, ubuntu, admin users to ssh in. 

## Usage

Sample playbook to run this role:

```Yaml
---
- hosts: host1
  become: yes
  remote_user: root
  gather_facts: no
  roles:
    - { role: "CIS-Ubuntu-20.04-Ansible",}
```

### Run all
If you want to run all tags use the below command:
```Bash
ansible-playbook -i [inventoryfile] [playbook].yaml
```
### Run specfic section
```Bash
ansible-playbook -i host run.yaml -t section2
```
### Run multi sections
```Bash
ansible-playbook -i host run.yaml -t section2 -t 6.1.1
```
