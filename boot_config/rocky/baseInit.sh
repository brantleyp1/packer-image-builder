#!/bin/bash -e
yum update -y
dnf install -y epel-release
dnf install -y open-vm-tools
dnf install -y wget
yum install -y python3
pip3 install ansible
systemctl stop sssd
systemctl disable sssd
systemctl stop firewalld
systemctl disable firewalld
bash -c "echo 'add_drivers+=\" nvme \"' > /etc/dracut.conf.d/nvme.conf"
dracut --regenerate-all --force
exit
