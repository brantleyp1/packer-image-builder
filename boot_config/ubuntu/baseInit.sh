#!/bin/bash -ex
apt-get update
apt-get remove -y multipath-tools
apt-get install -y python3-pip
apt-get upgrade -y
/usr/bin/pip3 install ansible
chmod +x /usr/local/bin/ansible*
update-grub && sudo update-grub2
update-initramfs -u -v
df -h
exit
