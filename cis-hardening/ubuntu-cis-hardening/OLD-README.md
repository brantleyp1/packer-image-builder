<div align="center">
  <img src="https://raw.githubusercontent.com/alivx/CIS-Ubuntu-20.04-Ansible/master/files/header.png">
</div>


Ansible CIS Ubuntu 20.04 LTS Hardening [![Build Status](https://travis-ci.com/alivx/CIS-Ubuntu-20.04-Ansible.svg?branch=master)](https://travis-ci.com/alivx/CIS-Ubuntu-20.04-Ansible)
=========

CIS hardened Ubuntu: cyber attack and malware prevention for mission-critical systems
CIS benchmarks lock down your systems by removing:
1. non-secure programs.
2. disabling unused filesystems.
3. disabling unnecessary ports or services.
4. auditing privileged operations.
5. restricting administrative privileges.


CIS benchmark recommendations are adopted in virtual machines in public and private clouds. They are also used to secure on-premises deployments. For some industries, hardening a system against a publicly known standard is a criteria auditors look for. CIS benchmarks are often a system hardening choice recommended by auditors for industries requiring PCI-DSS and HIPPA compliance, such as banking, telecommunications and healthcare.
If you are attempting to obtain compliance against an industry-accepted security standard, like PCI DSS, APRA or ISO 27001, then you need to demonstrate that you have applied documented hardening standards against all systems within the scope of assessment.


The Ubuntu CIS benchmarks are organised into different profiles, namely **‘Level 1’** and **‘Level 2’** intended for server and workstation environments.


**A Level 1 profile** is intended to be a practical and prudent way to secure a system without too much performance impact.
* Disabling unneeded filesystems,
* Restricting user permissions to files and directories,
* Disabling unneeded services.
* Configuring network firewalls.

**A Level 2 profile** is used where security is considered very important and it may have a negative impact on the performance of the system.

* Creating separate partitions,
* Auditing privileged operations

The Ubuntu CIS hardening tool allows you to select the desired level of hardening against a profile (Level1 or Level 2) and the work environment (server or workstation) for a system.
Exmaple:
```Bash
ansible-playbook -i inventory cis-ubuntu-20.yaml --tags="level_1_server"
```
You can list all tags by running the below command:
```Bash
ansible-playbook -i host run.yaml --list-tags
```


I wrote all roles based on
```Text
CIS Ubuntu Linux 20.04 LTS Benchmark
v1.0.0 - 07-21-2020
```


**Check Example dir**
_________________


Requirements
------------

You should carefully read through the tasks to make sure these changes will not break your systems before running this playbook.

You can download Free CIS Benchmark book from this URL
[Free Benchmark](https://learn.cisecurity.org/benchmarks)


To start working in this Role you just need to install Ansible.
[Installing Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)


_________________

Role Variables
--------------

You have to review all default configuration before running this playbook, There are many role variables defined in defaults/main.yml.

* If you are considering applying this role to any servers, you should have a basic familiarity with the CIS Benchmark and an appreciation for the impact that it may have on a system.
* Read and change configurable default values.

Examples of config that should be immediately considered for exclusion:

**5.1.8 Ensure cron is restricted to authorized users** and **5.2.17 Ensure SSH access is limited**, which by default effectively limit access to the host (including via ssh).

**For example:**

* CIS-Ubuntu-20.04-Ansible/defaults/main.yml
```YAML

#Section 5
#5.1.8 Ensure cron is restricted to authorized users
allowd_hosts: "ALL: 0.0.0.0/0.0.0.0, 192.168.2.0/255.255.255.0"
# 5.2.17 Ensure SSH access is limited
allowed_users: ali saleh baker root #Put None or list of users space between each user

```

If you need you to change file templates, you can find it under `files/templates/*`


_________________

Dependencies
------------

* Ansible version > 2.9

_________________

Example Playbook
----------------

Below an example of a playbook

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
* Note:
When run an individual task be sure from the dependencies between tasks, for example, if you run tag **4.1.1.2 Ensure auditd service is enabled** before running **4.1.1.1 Ensure auditd is installed** you will get an error at the run time.

* Points with ~~Tilda~~ not implemented yet, currently I'm working on it.
* make sure to select one time service, for me I use ntp, but you can use other service such as [`systemd-timesyncd`,`ntp`,`chrony`] under the settings `defaults/main.yaml`
> Testing
> 11/1/2020 Tested on AWS EC2 ubuntu 20.04 LTS [Pass]
> 11/1/2020 Tested on local Ubuntu 20.04 LTS server [Pass]

* Before run make sure to update user list under `defaults/main.yaml` on `list_of_os_users` + `allowed_users`
* `Make` sure to set the right subnet under `defaults/main.yaml` on `allowd_hosts`

_________________


## Table of Roles:

 **1 Initial Setup**
  - 1.1 Filesystem Configuration
  - 1.1.1 Disable unused filesystems
  - 1.1.1.1 Ensure mounting of cramfs filesystems is disabled (Automated)
  - 1.1.1.2 Ensure mounting of freevxfs filesystems is disabled - (Automated)
  - 1.1.1.3 Ensure mounting of jffs2 filesystems is disabled (Automated)
  - 1.1.1.4 Ensure mounting of hfs filesystems is disabled (Automated)
  - 1.1.1.5 Ensure mounting of hfsplus filesystems is disabled - (Automated)
  - 1.1.1.6 Ensure mounting of udf filesystems is disabled (Automated)
  - 1.1.1.7 Ensure mounting of FAT filesystems is limited (Manual)
  - 1.1.2 Ensure /tmp is configured (Automated)
  - 1.1.3 Ensure nodev option set on /tmp partition (Automated)
  - 1.1.4 Ensure nosuid option set on /tmp partition (Automated)
  - 1.1.5 Ensure noexec option set on /tmp partition (Automated)
  - 1.1.6 Ensure /dev/shm is configured (Automated)
  - 1.1.7 Ensure nodev option set on /dev/shm partition (Automated)
  - 1.1.8 Ensure nosuid option set on /dev/shm partition (Automated)
  - 1.1.9 Ensure noexec option set on /dev/shm partition (Automated)
  - ~~1.1.10 Ensure separate partition exists for /var (Automated)~~
  - ~~1.1.11 Ensure separate partition exists for /var/tmp (Automated)~~
  - ~~1.1.12 Ensure nodev option set on /var/tmp partition (Automated)~~
  - ~~1.1.13 Ensure nosuid option set on /var/tmp partition (Automated)~~
  - ~~1.1.14 Ensure noexec option set on /var/tmp partition (Automated)~~
  - ~~1.1.15 Ensure separate partition exists for /var/log (Automated)~~
  - ~~1.1.16 Ensure separate partition exists for /var/log/audit - (Automated)~~
  - ~~1.1.17 Ensure separate partition exists for /home (Automated)~~
  - ~~1.1.18 Ensure nodev option set on /home partition (Automated)~~
  - ~~1.1.19 Ensure nodev option set on removable media partitions (Manual)~~
  - ~~1.1.20 Ensure nosuid option set on removable media partitions - (Manual)~~
  - ~~1.1.21 Ensure noexec option set on removable media partitions - (Manual)~~
  - 1.1.22 Ensure sticky bit is set on all world-writable directories - (Automated)
  - 1.1.23 Disable Automounting (Automated)
  - 1.1.24 Disable USB Storage (Automated)

**1.2 Configure Software Updates**

  - ~~1.2.1 Ensure package manager repositories are configured (Manual)~~
  - ~~1.2.2 Ensure GPG keys are configured (Manual)~~

**1.3 Configure sudo**

  - 1.3.1 Ensure sudo is installed (Automated)
  - 1.3.2 Ensure sudo commands use pty (Automated)
  - 1.3.3 Ensure sudo log file exists (Automated)

**1.4 Filesystem Integrity Checking**

  - 1.4.1 Ensure AIDE is installed (Automated)
  - 1.4.2 Ensure filesystem integrity is regularly checked (Automated)

**1.5 Secure Boot Settings**

  - 1.5.1 Ensure bootloader password is set (Automated)
  - 1.5.2 Ensure permissions on bootloader config are configured - (Automated)
  - 1.5.3 Ensure authentication required for single user mode (Automated)

**1.6 Additional Process Hardening**
  - 1.6.1 Ensure XD/NX support is enabled (Automated)
  - 1.6.2 Ensure address space layout randomization (ASLR) is enabled - (Automated)
  - 1.6.3 Ensure prelink is disabled (Automated)
  - 1.6.4 Ensure core dumps are restricted (Automated)

**1.7 Mandatory Access Control**
  - 1.7.1 Configure AppArmor
  - 1.7.1.1 Ensure AppArmor is installed (Automated)
  - 1.7.1.2 Ensure AppArmor is enabled in the bootloader configuration - (Automated)
  - 1.7.1.3 Ensure all AppArmor Profiles are in enforce or complain mode - (Automated)
  - 1.7.1.4 Ensure all AppArmor Profiles are enforcing (Automated)

**1.8 Warning Banners**
  - 1.8.1 Command Line Warning Banners
  - 1.8.1.1 Ensure message of the day is configured properly (Automated)
  - 1.8.1.2 Ensure local login warning banner is configured properly - (Automated) 115
  - 1.8.1.3 Ensure remote login warning banner is configured properly - (Automated)
  - 1.8.1.4 Ensure permissions on /etc/motd are configured (Automated)
  - 1.8.1.5 Ensure permissions on /etc/issue are configured (Automated)
  - 1.8.1.6 Ensure permissions on /etc/issue.net are configured - (Automated)
  - 1.9 Ensure updates, patches, and additional security software are - installed (Manual)
  - 1.10 Ensure GDM is removed or login is configured (Automated)

**2 Services**
  - 2.1 inetd Services
  - 2.1.1 Ensure xinetd is not installed (Automated)
  - 2.1.2 Ensure openbsd-inetd is not installed (Automated)
  - 2.2 Special Purpose Services
  - 2.2.1 Time Synchronization
  - 2.2.1.1 Ensure time synchronization is in use (Automated)
  - 2.2.1.2 Ensure systemd-timesyncd is configured (Manual)
  - 2.2.1.3 Ensure chrony is configured (Automated)
  - 2.2.1.4 Ensure ntp is configured (Automated)
  - 2.2.2 Ensure X Window System is not installed (Automated)
  - 2.2.3 Ensure Avahi Server is not installed (Automated)
  - 2.2.4 Ensure CUPS is not installed (Automated)
  - 2.2.5 Ensure DHCP Server is not installed (Automated)
  - 2.2.6 Ensure LDAP server is not installed (Automated)
  - 2.2.7 Ensure NFS is not installed (Automated)
  - 2.2.8 Ensure DNS Server is not installed (Automated)
  - 2.2.9 Ensure FTP Server is not installed (Automated)
  - 2.2.10 Ensure HTTP server is not installed (Automated)
  - 2.2.11 Ensure IMAP and POP3 server are not installed (Automated)
  - 2.2.12 Ensure Samba is not installed (Automated)
  - 2.2.13 Ensure HTTP Proxy Server is not installed (Automated)
  - 2.2.14 Ensure SNMP Server is not installed (Automated)
  - 2.2.15 Ensure mail transfer agent is configured for local-only mode - (Automated)
  - 2.2.16 Ensure rsync service is not installed (Automated)
  - 2.2.17 Ensure NIS Server is not installed (Automated)

**2.3 Service Clients**
  - 2.3.1 Ensure NIS Client is not installed (Automated)
  - 2.3.2 Ensure rsh client is not installed (Automated)
  - 2.3.3 Ensure talk client is not installed (Automated)
  - 2.3.4 Ensure telnet client is not installed (Automated)
  - 2.3.5 Ensure LDAP client is not installed (Automated)
  - 2.3.6 Ensure RPC is not installed (Automated)
  - ~~2.4 Ensure nonessential services are removed or masked (Manual)~~

**3 Network Configuration**
  - 3.1 Disable unused network protocols and devices
  - 3.1.1 Disable IPv6 (Manual)
  - 3.1.2 Ensure wireless interfaces are disabled (Automated)

**3.2 Network Parameters (Host-Only)**
  - 3.2.1 Ensure packet redirect sending is disabled (Automated)
  - 3.2.2 Ensure IP forwarding is disabled (Automated)

**3.3 Network Parameters (Host and Router)**
  - 3.3.1 Ensure source-routed packets are not accepted (Automated)
  - 3.3.2 Ensure ICMP redirects are not accepted (Automated)
  - 3.3.3 Ensure secure ICMP redirects are not accepted (Automated)
  - 3.3.4 Ensure suspicious packets are logged (Automated)
  - 3.3.5 Ensure broadcast ICMP requests are ignored (Automated)
  - 3.3.6 Ensure bogus ICMP responses are ignored (Automated)
  - 3.3.7 Ensure Reverse Path Filtering is enabled (Automated)
  - 3.3.8 Ensure TCP SYN Cookies is enabled (Automated)
  - 3.3.9 Ensure IPv6 router advertisements are not accepted (Automated)

**3.4 Uncommon Network Protocols**
  - 3.4.1 Ensure DCCP is disabled (Automated)
  - 3.4.2 Ensure SCTP is disabled (Automated)
  - 3.4.3 Ensure RDS is disabled (Automated)
  - 3.4.4 Ensure TIPC is disabled (Automated)

**3.5 Firewall Configuration**
  - 3.5.1 Configure UncomplicatedFirewall
  - 3.5.1.1 Ensure Uncomplicated Firewall is installed (Automated)
  - 3.5.1.2 Ensure iptables-persistent is not installed (Automated)
  - 3.5.1.3 Ensure ufw service is enabled (Automated)
  - 3.5.1.4 Ensure loopback traffic is configured (Automated)
  - 3.5.1.5 Ensure outbound connections are configured (Manual)
  - 3.5.1.6 Ensure firewall rules exist for all open ports (Manual)
  - 3.5.1.7 Ensure default deny firewall policy (Automated)
  - ~~3.5.2 Configure nftables~~
  - ~~3.5.2.1 Ensure nftables is installed (Automated)~~
  - ~~3.5.2.2 Ensure Uncomplicated Firewall is not installed or disabled - (Automated)~~
  - ~~3.5.2.3 Ensure iptables are flushed (Manual)~~
  - ~~3.5.2.4 Ensure a table exists (Automated)~~
  - ~~3.5.2.5 Ensure base chains exist (Automated)~~
  - ~~3.5.2.6 Ensure loopback traffic is configured (Automated)~~
  - ~~3.5.2.7 Ensure outbound and established connections are configured - (Manual)243~~
  - ~~3.5.2.8 Ensure default deny firewall policy (Automated)~~
  - ~~3.5.2.9 Ensure nftables service is enabled (Automated)~~
  - ~~3.5.2.10 Ensure nftables rules are permanent (Automated)~~
  - ~~3.5.3 Configure iptables~~
  - ~~3.5.3.1.1 Ensure iptables packages are installed (Automated)~~
  - ~~3.5.3.1.2 Ensure nftables is not installed (Automated)~~
  - ~~3.5.3.1.3 Ensure Uncomplicated Firewall is not installed or disabled - (Automated)~~
  - ~~3.5.3.2.1 Ensure default deny firewall policy (Automated)~~
  - ~~3.5.3.2.2 Ensure loopback traffic is configured (Automated)~~
  - ~~3.5.3.2.3 Ensure outbound and established connections are configured - (Manual)~~
  - ~~3.5.3.2.4 Ensure firewall rules exist for all open ports (Automated)~~
  - ~~3.5.3.3.1 Ensure IPv6 default deny firewall policy (Automated)~~
  - ~~3.5.3.3.2 Ensure IPv6 loopback traffic is configured (Automated)~~
  - ~~3.5.3.3.3 Ensure IPv6 outbound and established connections are - configured (Manual)~~
  - ~~3.5.3.3.4 Ensure IPv6 firewall rules exist for all open ports - (Manual)~~

**4 Logging and Auditing**
  - 4.1 Configure System Accounting (auditd)
  - 4.1.1 Ensure auditing is enabled
  - 4.1.1.1 Ensure auditd is installed (Automated)
  - 4.1.1.2 Ensure auditd service is enabled (Automated)
  - 4.1.1.3 Ensure auditing for processes that start prior to auditd is - enabled (Automated)
  - 4.1.1.4 Ensure audit_backlog_limit is sufficient (Automated)
  - 4.1.2 Configure Data Retention
  - 4.1.2.1 Ensure audit log storage size is configured (Automated)
  - 4.1.2.2 Ensure audit logs are not automatically deleted (Automated)
  - 4.1.2.3 Ensure system is disabled when audit logs are full - (Automated)
  - 4.1.3 Ensure events that modify date and time information are - collected (Automated)
  - 4.1.4 Ensure events that modify user/group information are collected - (Automated)
  - 4.1.5 Ensure events that modify the system's network environment are - collected (Automated)
  - 4.1.6 Ensure events that modify the system's Mandatory Access - Controls are collected (Automated)
  - 4.1.7 Ensure login and logout events are collected (Automated)
  - 4.1.8 Ensure session initiation information is collected (Automated)
  - 4.1.9 Ensure discretionary access control permission modification - events are collected (Automated)
  - 4.1.10 Ensure unsuccessful unauthorized file access attempts are - collected (Automated)
  - 4.1.11 Ensure use of privileged commands is collected (Automated)
  - 4.1.12 Ensure successful file system mounts are collected (Automated)
  - 4.1.13 Ensure file deletion events by users are collected (Automated)
  - 4.1.14 Ensure changes to system administration scope (sudoers) is - collected (Automated)
  - 4.1.15 Ensure system administrator command executions (sudo) are - collected (Automated)
  - 4.1.16 Ensure kernel module loading and unloading is collected - (Automated)
  - 4.1.17 Ensure the audit configuration is immutable (Automated)

**4.2 Configure Logging**
  - 4.2.1 Configure rsyslog
  - 4.2.1.1 Ensure rsyslog is installed (Automated)
  - 4.2.1.2 Ensure rsyslog Service is enabled (Automated)
  - 4.2.1.3 Ensure logging is configured (Manual)
  - 4.2.1.4 Ensure rsyslog default file permissions configured - (Automated)
  - 4.2.1.5 Ensure rsyslog is configured to send logs to a remote log - host (Automated)
  - 4.2.1.6 Ensure remote rsyslog messages are only accepted on - designated log hosts. (Manual)
  - 4.2.2 Configure journald
  - 4.2.2.1 Ensure journald is configured to send logs to rsyslog - (Automated)
  - 4.2.2.2 Ensure journald is configured to compress large log files - (Automated)
  - 4.2.2.3 Ensure journald is configured to write logfiles to - persistent disk (Automated)
  - 4.2.3 Ensure permissions on all logfiles are configured (Automated)
  - 4.3 Ensure logrotate is configured (Manual)
  - 4.4 Ensure logrotate assigns appropriate permissions (Automated)

**5 Access, Authentication and Authorization**
  - 5.1 Configure time-based job schedulers
  - 5.1.1 Ensure cron daemon is enabled and running (Automated)
  - 5.1.2 Ensure permissions on /etc/crontab are configured (Automated)
  - 5.1.3 Ensure permissions on /etc/cron.hourly are configured - (Automated)
  - 5.1.4 Ensure permissions on /etc/cron.daily are configured - (Automated)
  - 5.1.5 Ensure permissions on /etc/cron.weekly are configured - (Automated)
  - 5.1.6 Ensure permissions on /etc/cron.monthly are configured - (Automated)
  - 5.1.7 Ensure permissions on /etc/cron.d are configured (Automated)
  - 5.1.8 Ensure cron is restricted to authorized users (Automated)
  - 5.1.9 Ensure at is restricted to authorized users (Automated)

**5.2 Configure SSH Server**
  - 5.2.1 Ensure permissions on /etc/ssh/sshd_config are configured - (Automated)
  - 5.2.2 Ensure permissions on SSH private host key files are - configured (Automated)
  - 5.2.3 Ensure permissions on SSH public host key files are configured - (Automated)
  - 5.2.4 Ensure SSH LogLevel is appropriate (Automated)
  - 5.2.5 Ensure SSH X11 forwarding is disabled (Automated)
  - 5.2.6 Ensure SSH MaxAuthTries is set to 4 or less (Automated)
  - 5.2.7 Ensure SSH IgnoreRhosts is enabled (Automated)
  - 5.2.8 Ensure SSH HostbasedAuthentication is disabled (Automated)
  - 5.2.9 Ensure SSH root login is disabled (Automated)
  - 5.2.10 Ensure SSH PermitEmptyPasswords is disabled (Automated)
  - 5.2.11 Ensure SSH PermitUserEnvironment is disabled (Automated)
  - 5.2.12 Ensure only strong Ciphers are used (Automated)
  - 5.2.13 Ensure only strong MAC algorithms are used (Automated)
  - 5.2.14 Ensure only strong Key Exchange algorithms are used - (Automated)
  - 5.2.15 Ensure SSH Idle Timeout Interval is configured (Automated)
  - 5.2.16 Ensure SSH LoginGraceTime is set to one minute or less - (Automated)
  - 5.2.17 Ensure SSH access is limited (Automated)
  - 5.2.18 Ensure SSH warning banner is configured (Automated)
  - 5.2.19 Ensure SSH PAM is enabled (Automated)
  - 5.2.20 Ensure SSH AllowTcpForwarding is disabled (Automated)
  - 5.2.21 Ensure SSH MaxStartups is configured (Automated)
  - 5.2.22 Ensure SSH MaxSessions is limited (Automated)

**5.3 Configure PAM**
  - 5.3.1 Ensure password creation requirements are configured - (Automated)
  - 5.3.2 Ensure lockout for failed password attempts is configured - (Automated)
  - 5.3.3 Ensure password reuse is limited (Automated)
  - 5.3.4 Ensure password hashing algorithm is SHA-512 (Automated)

**5.4 User Accounts and Environment**
  - 5.4.1 Set Shadow Password Suite Parameters
  - 5.4.1.1 Ensure password expiration is 365 days or less (Automated)
  - 5.4.1.2 Ensure minimum days between password changes is configured - (Automated)
  - 5.4.1.3 Ensure password expiration warning days is 7 or more - (Automated)
  - 5.4.1.4 Ensure inactive password lock is 30 days or less (Automated)
  - 5.4.1.5 Ensure all users last password change date is in the past - (Automated)
  - 5.4.2 Ensure system accounts are secured (Automated)
  - 5.4.3 Ensure default group for the root account is GID 0 (Automated)
  - 5.4.4 Ensure default user umask is 027 or more restrictive - (Automated)
  - 5.4.5 Ensure default user shell timeout is 900 seconds or less - (Automated)
  - 5.5 Ensure root login is restricted to system console (Manual)
  - 5.6 Ensure access to the su command is restricted (Automated)

**6 System Maintenance**
  - 6.1 System File Permissions
  - ~~6.1.1 Audit system file permissions (Manual)~~
  - 6.1.2 Ensure permissions on /etc/passwd are configured (Automated)
  - 6.1.3 Ensure permissions on /etc/gshadow- are configured Automated)
  - 6.1.4 Ensure permissions on /etc/shadow are configured (Automated)
  - 6.1.5 Ensure permissions on /etc/group are configured (Automated)
  - 6.1.6 Ensure permissions on /etc/passwd- are configured (Automated)
  - 6.1.7 Ensure permissions on /etc/shadow- are configured (Automated)
  - 6.1.8 Ensure permissions on /etc/group- are configured (Automated)
  - 6.1.9 Ensure permissions on /etc/gshadow are configured (Automated)
  - 6.1.10 Ensure no world writable files exist (Automated)
  - 6.1.11 Ensure no unowned files or directories exist (Automated)
  - 6.1.12 Ensure no ungrouped files or directories exist (Automated)
  - ~~6.1.13 Audit SUID executables (Manual)~~
  - ~~6.1.14 Audit SGID executables (Manual)~~

**6.2 User and Group Settings**
  - 6.2.1 Ensure password fields are not empty (Automated)
  - ~~6.2.2 Ensure root is the only UID 0 account (Automated)~~
  - ~~6.2.3 Ensure root PATH Integrity (Automated)~~
  - 6.2.4 Ensure all users' home directories exist (Automated)
  - 6.2.5 Ensure users' home directories permissions are 750 or more - restrictive (Automated)
  - 6.2.6 Ensure users own their home directories (Automated)
  - 6.2.7 Ensure users' dot files are not group or world writable - (Automated)
  - ~~6.2.8 Ensure no users have .forward files (Automated)~~
  - ~~6.2.9 Ensure no users have .netrc files (Automated)~~
  - ~~6.2.10 Ensure users' .netrc Files are not group or world accessible - (Automated)~~
  - ~~6.2.11 Ensure no users have .rhosts files (Automated)~~
  - ~~6.2.12 Ensure aFor ll groups in /etc/passwd exist in /etc/group - (Automated)~~
  - ~~6.2.13 Ensure no duplicate UIDs exist (Automated)~~
  - ~~6.2.14 Ensure no duplicate GIDs exist (Automated)~~
  - ~~6.2.15 Ensure no duplicate user names exist (Automated)~~
  - ~~6.2.16 Ensure no duplicate group names exist (Automated)~~
  - ~~6.2.17 Ensure shadow group is empty (Automated)~~

_________________
## Troubleshooting
* If you want to run the playbook in the same machine, make sure to add this to run task:
```
- hosts: 127.0.0.1
  connection: local
```
* if you faced issue with execut, try to run the playbook in another path, like `/srv/`.
* For error like this `stderr: chage: user 'ubuntu' does not exist in /etc/passed`, make sure to update config under `CIS-Ubuntu-20.04-Ansible/defaults/main.yml`


```Bash
TASK [CIS-Ubuntu-20.04-Ansible : 1.4.1 Ensure AIDE is installed] ***********************************************************************************************************************************************************************************************************fatal: [192.168.80.129]: FAILED! => {"cache_update_time": 1611229159, "cache_updated": false, "changed": false, "msg": "'/usr/bin/apt-get -y -o \"Dpkg::Options::=--force-confdef\" -o \"Dpkg::Options::=--force-confold\"      install 'nullmailer' 'aide-common' 'aide' -o APT::Install-Recommends=no' failed: E: Could not get lock /var/lib/dpkg/lock-frontend. It is held by process 5194 (unattended-upgr)\nE: Unable to acquire the dpkg frontend lock (/var/lib/dpkg/lock-frontend), is another process using it?\n", "rc": 100, "stderr": "E: Could not get lock /var/lib/dpkg/lock-frontend. It is held by process 5194 (unattended-upgr)\nE: Unable to acquire the dpkg frontend lock (/var/lib/dpkg/lock-frontend), is another process using it?\n", "stderr_lines": ["E: Could not get lock /var/lib/dpkg/lock-frontend. It is held by process 5194 (unattended-upgr)", "E: Unable to acquire the dpkg frontend lock (/var/lib/dpkg/lock-frontend), is another process using it?"], "stdout": "", "stdout_lines": []}
```
* For the above error you need to make sure there is not apt process running in the background, or you must wait until apt finish the process.

```Bash
TASK [CIS-Ubuntu-20.04-Ansible : 5.4.1.1 Ensure password expiration is 365 days or less | chage] ***************************************************************************************************************************************************************************failed: [192.168.80.129] (item=ubuntu) => {"ansible_loop_var": "item", "changed": true, "cmd": ["chage", "--maxdays", "300", "ubuntu"], "delta": "0:00:00.005478", "end": "2021-01-21 12:49:45.463615", "item": "ubuntu", "msg": "non-zero return code", "rc": 1, "start": "2021-01-21 12:49:45.458137", "stderr": "chage: user 'ubuntu' does not exist in /etc/passwd", "stderr_lines": ["chage: user 'ubuntu' does not exist in /etc/passwd"], "stdout": "", "stdout_lines": []}
```
* Make sure you set the right user under defaults/main.yaml

_________________


License
-------

 GNU GENERAL PUBLIC LICENSE

Author Information
------------------

The role was originally developed by [Ali Saleh Baker](https://www.linkedin.com/in/alivx/).

When contributing to this repository, please first discuss the change you wish to make via a GitHub issue,  email, or via other channels with me :)
