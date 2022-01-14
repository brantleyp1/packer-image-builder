locals {
  linux_notes = "Template based on ${ var.os_family }-${ var.os_version } with CIS hardening, built using packer on {{ isotime \"2006-01-02\" }} at {{isotime \"3:04PM\"}}"
  win_notes = "Template based on ${ var.os_family } ${ var.os_version }, built using packer on {{ isotime \"2006-01-02\" }} at {{isotime \"3:04PM\"}}"
  speedtest_notes = "Speedtest template based on ${ var.os_family }-${ var.os_version } LTS with CIS hardening, built using packer on {{ isotime \"2006-01-02\" }} at {{isotime \"3:04PM\"}}"
  vm_name               = "${ var.os_family }${ var.os_version }"
}

source "vsphere-iso" "windows" {
  # vCenter settings
  vcenter_server      = var.vcenter_server
  username            = var.vcenter_username
  password            = var.vcenter_password
  insecure_connection = var.vcenter_connection
  cluster             = var.vcenter_cluster
  datacenter          = var.vcenter_datacenter
  host                = var.vcenter_host
  datastore           = var.vcenter_datastore
  convert_to_template = var.convert_to_template

  # VM Settings
  boot_wait             = "5s"
  ip_wait_timeout       = "45m"
  communicator          = "winrm"
  winrm_username        = var.connection_username
  winrm_password        = var.connection_password
  winrm_timeout         = "4h"
  winrm_port            = "5985"
  shutdown_command      = "shutdown /s /t 5 /f /d p:4:1 /c \"Packer Shutdown\""
  shutdown_timeout      = "30m"
  vm_version            = var.vm_hardware_version
  iso_paths              = [
      var.os_iso_path
  ]
  iso_checksum          = var.iso_checksum
  vm_name               = "build-${local.vm_name}"
  guest_os_type         = var.guest_os_type
  disk_controller_type  = ["pvscsi"] # Windows requires vmware tools drivers for pvscsi to work
  network_adapters {
    # For windows, the vmware tools network drivers are required to be connected by floppy before tools is installed
    network = var.vm_network
    network_card = var.nic_type
  }
  storage {
    disk_size = var.root_disk_size
    disk_thin_provisioned = true
  }
  CPUs                  = var.num_cpu
  cpu_cores             = var.num_cores
  CPU_hot_plug          = true
  RAM                   = var.vm_ram
  RAM_hot_plug          = true
  floppy_files          = [
      "./boot_config/${var.os_version}/Autounattend.xml",
      "./scripts/winrm.bat",
      "./scripts/Install-VMWareTools.ps1",
      "./drivers/"
  ]
  content_library_destination {
    datastore   = var.vcenter_datastore
    description = local.linux_notes
    host        = var.vcenter_host
    library     = var.vcenter_content_library
    name        = "template_${local.vm_name}"
    ovf         = "true"
  }
  notes           = local.win_notes
}

source "vsphere-iso" "ubuntu" {
  # vCenter settings
  vcenter_server      = var.vcenter_server
  username            = var.vcenter_username
  password            = var.vcenter_password
  insecure_connection = var.vcenter_connection
  cluster             = var.vcenter_cluster
  datacenter          = var.vcenter_datacenter
  host                = var.vcenter_host
  datastore           = var.vcenter_datastore
  convert_to_template = var.convert_to_template

  # VM Settings
  ip_wait_timeout       = "45m"
  ssh_username          = var.connection_username
  ssh_password          = var.connection_password
  ssh_timeout           = "20m"
  ssh_port              = "22"
  ssh_handshake_attempts = "100"
  shutdown_timeout      = "15m"
  vm_version            = var.vm_hardware_version
  iso_paths             = [var.os_iso_path]
  iso_checksum          = var.iso_checksum
  vm_name               = "build-${local.vm_name}"
  guest_os_type         = var.guest_os_type
  disk_controller_type  = ["pvscsi"]
  network_adapters {
    network = var.vm_network
    network_card = var.nic_type
  }
  storage {
    disk_size = var.root_disk_size
    disk_thin_provisioned = true
  }
  CPUs                  = var.num_cpu
  cpu_cores             = var.num_cores
  CPU_hot_plug          = true
  RAM                   = var.vm_ram
  RAM_hot_plug          = true
  boot_wait             = "5s"
  boot_command          = var.boot_command

  ## new things to watch
  notes           = local.linux_notes
  cd_files        = [
    "./boot_config/${var.os_family}/meta-data",
    "./boot_config/${var.os_family}/user-data",
    "./boot_config/${var.os_family}/preseed.cfg"
    ]
  cd_label        = "cidata"
  floppy_files    = ["./boot_config/${var.os_family}/preseed.cfg"]
  content_library_destination {
    datastore   = var.vcenter_datastore
    description = local.linux_notes
    host        = var.vcenter_host
    library     = var.vcenter_content_library
    name        = "template_${local.vm_name}"
    ovf         = "true"
  }
}

source "vsphere-iso" "rocky" {
  # vCenter settings
  vcenter_server      = var.vcenter_server
  username            = var.vcenter_username
  password            = var.vcenter_password
  insecure_connection = var.vcenter_connection
  cluster             = var.vcenter_cluster
  datacenter          = var.vcenter_datacenter
  host                = var.vcenter_host
  datastore           = var.vcenter_datastore
  convert_to_template = var.convert_to_template

  # VM Settings
  ip_wait_timeout       = "45m"
  ssh_username          = var.connection_username
  ssh_password          = var.connection_password
  ssh_timeout           = "20m"
  ssh_port              = "22"
  ssh_handshake_attempts = "100"
  shutdown_timeout      = "15m"
  vm_version            = var.vm_hardware_version
  iso_paths             = [var.os_iso_path]
  iso_checksum          = var.iso_checksum
  vm_name               = "build-${local.vm_name}"
  guest_os_type         = var.guest_os_type
  disk_controller_type  = ["pvscsi"]
  network_adapters {
    network = var.vm_network
    network_card = var.nic_type
  }
  storage {
    disk_size = var.root_disk_size
    disk_thin_provisioned = true
  }
  CPUs                  = var.num_cpu
  cpu_cores             = var.num_cores
  CPU_hot_plug          = true
  RAM                   = var.vm_ram
  RAM_hot_plug          = true
  boot_wait             = "5s"
  boot_command          = var.boot_command

  ## new things to watch
  notes           = local.linux_notes
  cd_files = [
    "./boot_config/${var.os_family}/ks.cfg",
  ]
  content_library_destination {
    datastore   = var.vcenter_datastore
    description = local.linux_notes
    host        = var.vcenter_host
    library     = var.vcenter_content_library
    name        = "template_${local.vm_name}"
    ovf         = "true"
  }

  cd_label = "cidata"

}

## windows build
build {
    # Windows builds
    sources = [
        "source.vsphere-iso.windows",
    ]
    provisioner "powershell" {
        pause_before = "1m"
        elevated_user = var.connection_username
        elevated_password = var.connection_password
        scripts = [
            "scripts/Disable-UAC.ps1"
        ]
    }
    provisioner "powershell" {
        pause_before = "1m"
        elevated_user = var.connection_username
        elevated_password = var.connection_password
        scripts = [
            "scripts/setup.ps1"
        ]
    }
    provisioner "powershell" {
        pause_before = "1m"
        elevated_user = var.connection_username
        elevated_password = var.connection_password
        scripts = [
            "scripts/convertEval.ps1"
        ]
    }
    provisioner "windows-restart" {
        restart_timeout = "30m"
    }
    provisioner "powershell" {
        pause_before = "1m"
        elevated_user = var.connection_username
        elevated_password = var.connection_password
        scripts = [
            "scripts/win-update.ps1"
        ]
    }
    provisioner "windows-restart" {
        restart_timeout = "30m"
    }
    provisioner "powershell" {
        pause_before = "5m"
        elevated_user = var.connection_username
        elevated_password = var.connection_password
        scripts = [
            "scripts/win-update.ps1"
        ]
    }
    provisioner "windows-restart" {
        restart_timeout = "30m"
    }
        
    provisioner "powershell" {
        elevated_user = var.connection_username
        elevated_password = var.connection_password
        pause_before = "1m"
        scripts = [
            "scripts/Remove-UpdateCache.ps1",
            "scripts/Invoke-Defrag.ps1",
            "scripts/cleanup.ps1",
            "scripts/Reset-EmptySpace.ps1"
        ]
    }
}

## ubuntu build
build { 
    sources = [
        "source.vsphere-iso.ubuntu",
    ]

    provisioner "shell" {
      execute_command = "sudo -S bash {{ .Path }}"
      script          = "./boot_config/ubuntu/baseInit.sh"
    }

    provisioner "ansible-local" {
      playbook_dir  = "cis-hardening/ubuntu-ansible"
      playbook_file = "cis-hardening/ubuntu-ansible/playbook.yml"
      role_paths    = ["cis-hardening/ubuntu-cis-hardening"]
    }

    provisioner "ansible" {
      playbook_file = "/etc/ansible/playbook/roster.yml"
    }

    provisioner "shell" {
      execute_command = "sudo -S bash {{ .Path }}"
      script          = "./boot_config/ubuntu/post_cleanup.sh"
    }
}

## rocky build
build {
    sources = [
        "source.vsphere-iso.rocky",
    ]
    provisioner "shell" {
      execute_command = "sudo -S bash {{ .Path }}"
      script          = "./boot_config/${var.os_family}/baseInit.sh"
    }

    provisioner "ansible-local" {
      playbook_dir  = "cis-hardening/rocky-ansible"
      playbook_file = "cis-hardening/rocky-ansible/playbook.yml"
      role_paths    = ["cis-hardening/rocky-cis-hardening"]
    }

    provisioner "ansible" {
      playbook_file = "/etc/ansible/playbook/roster.yml"
    }
    provisioner "shell" {
      execute_command = "sudo -S bash {{ .Path }}"
      script          = "./boot_config/${var.os_family}/post_cleanup.sh"
    }
}