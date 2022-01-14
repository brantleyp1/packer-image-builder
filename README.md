# Packer with HCL and vsphere-iso/vmware-iso

This repo gives a few examples using the latest packer (v1.5.0+) and HCL.  HCL enables a lot of neat new abilities, but I couldn't find any examples for vsphere-iso or other non-cloud configurations.

This is based on [tvories](https://github.com/tvories/packer-vsphere-hcl) repo but has been expanded to include locally built (using vmware fusion, should work with workstation as well), as well as convert the Centos builder to Rocky Linux. Also reworked the folder structure a little in order to include CIS Hardening roles.

This could be broken out to multiple different config setups, but I like the fact there's only a few places to make changes. 

For example, I built the portion for Rocky, but the only changes that would be required to build it as rhel/centos should be to substitute the ISO and ISO checksum and change the family from rocky to the correct family. 

Also, these builds do not use/require an http process (though packer still creates one). I work remotely and had to resort to building a kickstart server running nginx in order to server out kickstart files because the vm wasn't able to hit my local http:port. Instead, these builds put everything either in cd_files (rocky), or floppy_files (windows/ubuntu), which simplifies the build a little.

<!-- TODO: add requirements section -->
## Usage

The `vsphere.pkr.hcl` file is the main packer configuration file for building on vsphere/virtual center.  The `vmware.pkr.hcl` file is the main packer configuration file for building on your local system.

To build Ubuntu 20.04: `packer build --only vsphere-iso.ubuntu --var-file=20.04.pkrvars.hcl .`

You can target specific builds with the `--only` parameter.

Each OS family has its own `source` and `builder` block in the `vsphere.pkr.hcl` file.  Each specific OS version (IE ubuntu **20.04** or rocky **8**) has its own variable file that contains the unique variables for the os.  This means that you can build Ubuntu 20.04 from the same `builder` block as Ubuntu 18.04.

A few examples:

Ubuntu 18.04: `packer build --only vsphere-iso.ubuntu --var-file=18.04.pkrvars.hcl .`

Windows Server 2019: `packer build --only vsphere-iso.windows --var-file=2019.pkrvars.hcl .`

Rocky 8: `packer build -force --only vmware-iso.rocky --var-file=rocky8.pkrvars.hcl .`

Note the trailing `.` at the end of the command.  That is telling packer to build everything in the current directory.  This is key for any `auto.pkrvars.hcl` to be automatically populated.

## Directory Structure

`boot_config` - Stores kickstart, answerfiles, and preseed files.

```bash
boot_config/
├── 2019
│   └── Autounattend.xml
├── 2022
│   └── Autounattend.xml
├── rocky
│   └── rocky-ks.cfg
└── speedtest
    ├── meta-data
    ├── preseed.cfg
    └── user-data
└── ubuntu
    ├── meta-data
    ├── preseed.cfg
    └── user-data
```
These are named as to be targeted by the packer variables `os_family` and `os_version`.  This is so you can dynamically pick the correct `boot_config` files.

`cis-hardening` - Stores ansible role info to harden the OS according to CIS recommendations. 

```bash
cis-hardening
├── rocky-ansible
├── rocky-cis-hardening
├── ubuntu-ansible
└── ubuntu-cis-hardening
```
Currently only hardening Linux OSs, the *-ansible folder contains a playbook that calls role, i.e. `ubuntu-ansible/playbook.yml` calls the `ubuntu-cis-hardening` role.

`ubuntu-cis-hardening` role is borrowed heavily from alivx's [GitHub](https://github.com/alivx/CIS-Ubuntu-20.04-Ansible) role.
`rocky-cis-hardening` role is based almost entirely on [HarryHarcourt](https://github.com/HarryHarcourt/Ansible-RHEL8-CIS-Benchmarks)'s role.
Any changes to either role should be submitted to the main repos

`drivers` - VMware Tools drivers for Windows pvscsi driver and VMXNET3 driver.  This allows Windows to come up with storage and network without needing to have VMware Tools installed during intial boot.

`scripts` - Scripts used for bootstrapping the OSes.

`root directory` - Where the actual key packer files exist.

## Key files

### `vsphere.pkr.hcl`

This is where the sources and builds for VSphere are defined.  Every build is triggered from this file.  It includes Ubuntu, rocky, and Windows sources and builds.

### `vmware.pkr.hcl`

This is where the sources and builds for VMWare are defined.  Every build is triggered from this file.  It includes Ubuntu, rocky, and Windows sources and builds.


### `variables.pkr.hcl`

This is where the hcl variables are declared.  You could potentially put this at the top of your `vsphere.pkr.hcl` file, but it's good practice to keep your variables files separate.

There are some defaults defined in this file, but for the most part variables are declared in the individual OS variable files.

### Individual OS variable files

`2019.pkrvars.hcl`
  - Windows 2019 Eval build options

`2022.pkrvars.hcl`
  - Windows 2022 Eval build options

`18.04.pkrvars.hcl`
  - Ubuntu 18.04.06LTS build options

`20.04.pkrvars.hcl`
  - Ubuntu 20.04.02LTS build options

`20.04-speedtest.pkrvars.hcl`
  - Ubuntu 20.04.02LTS build options for a specific speedtest build

`rocky8.pkrvars.hcl`
  - Rocky Linux 8 build - should be compatible with RHEL8/CENTOS8/AmalLinux8

These files are specifically provided during the packer command to tell packer which build to process.  An example packer command would be: `packer build -force --only vsphere-iso.windows --var-file=2019.pkrvars.hcl .`

Note the trailing period in that command.  That is telling packer to build everything in the directory, which is required to get the `auto.pkrvars.hcl` to work correctly.  Note in that command the `--only` flag.  That tells packer to only build the `vsphere-iso.windows` source.
