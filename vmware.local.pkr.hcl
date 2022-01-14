locals {
  linux_notes = "Template based on ${ var.os_family }-${ var.os_version } with CIS hardening, built using packer on {{ isotime \"2006-01-02\" }} at {{isotime \"3:04PM\"}}"
  win_notes = "Template based on ${ var.os_family } ${ var.os_version }, built using packer on {{ isotime \"2006-01-02\" }} at {{isotime \"3:04PM\"}}"
  speedtest_notes = "Speedtest template based on ${ var.os_family }-${ var.os_version } LTS with CIS hardening, built using packer on {{ isotime \"2006-01-02\" }} at {{isotime \"3:04PM\"}}"
  vm_name               = "${ var.os_family }${ var.os_version }"
}

source "vmware-iso" "windows" {
  # VM Settings
  communicator          = "winrm"
  winrm_username        = var.connection_username
  winrm_password        = var.connection_password
  winrm_timeout         = "4h"
  winrm_port            = "5985"
  shutdown_command      = "shutdown /s /t 5 /f /d p:4:1 /c \"Packer Shutdown\""
  shutdown_timeout      = "30m"
  version               = var.vm_hardware_version_local
  iso_url               = var.os_iso_url
  iso_checksum          = var.iso_checksum
  vm_name               = local.vm_name
  vmdk_name             = local.vm_name
  guest_os_type         = var.guest_os_type_local
  disk_adapter_type     = "lsisas1068"
  network_adapter_type  = var.nic_type # For windows, the vmware tools network drivers are required to be connected by floppy before tools is installed
  disk_size             = var.root_disk_size
  cpus                  = var.num_cpu
  cores                 = var.num_cores
  memory                = var.vm_ram
  output_directory      = "${var.output_directory}/${local.vm_name}"
  floppy_files          = [
      "./boot_config/${var.os_version}/Autounattend.xml",
      "./scripts/winrm.bat",
      "./scripts/Install-VMWareTools.ps1",
      "./drivers/"
  ]
}

source "vmware-iso" "ubuntu" {
  # VM Settings
  ssh_username           = var.connection_username
  ssh_password           = var.connection_password
  ssh_timeout            = "20m"
  ssh_port               = "22"
  ssh_handshake_attempts = "100"
  shutdown_command       = "sudo systemctl poweroff"
  shutdown_timeout       = "15m"
  version                = var.vm_hardware_version_local
  iso_url                = var.os_iso_url
  iso_checksum           = var.iso_checksum
  vm_name                = local.vm_name
  vmdk_name              = local.vm_name
  guest_os_type          = var.guest_os_type_local
  //disk_adapter_type    = "scsi"
  network_adapter_type   = var.nic_type
  disk_size              = var.root_disk_size
  cpus                   = var.num_cpu
  cores                  = var.num_cores
  memory                 = var.vm_ram
  boot_wait              = "5s"
  boot_command           = var.boot_command

  ## new things to watch
  cd_files        = [
    "./boot_config/${var.os_family}/meta-data",
    "./boot_config/${var.os_family}/user-data",
    "./boot_config/${var.os_family}/preseed.cfg"
    ]
  cd_label        = "cidata"
  output_directory      = "${var.output_directory}/${local.vm_name}"
  floppy_files    = ["./boot_config/${var.os_family}/preseed.cfg"]
}

source "vmware-iso" "rocky" {
  # VM Settings
  ssh_username           = var.connection_username
  ssh_password           = var.connection_password
  ssh_timeout            = "20m"
  ssh_port               = "22"
  ssh_handshake_attempts = "100"
  shutdown_command       = "sudo systemctl poweroff"
  shutdown_timeout       = "15m"
  version                = var.vm_hardware_version_local
  iso_url                = var.os_iso_url
  iso_checksum           = var.iso_checksum
  guest_os_type          = var.guest_os_type
  vm_name                = local.vm_name
  vmdk_name              = local.vm_name
  //disk_adapter_type    = "scsi"
  network_adapter_type   = var.nic_type
  disk_size              = var.root_disk_size
  cpus                   = var.num_cpu
  cores                  = var.num_cores
  memory                 = var.vm_ram
  boot_wait              = "5s"
  boot_command           = var.boot_command

  ## new things to watch
  cd_files = [
    "./boot_config/${var.os_family}/ks.cfg",
  ]

  cd_label = "cidata"
  output_directory      = "${var.output_directory}/${local.vm_name}"

}

## windows build
build {
    # Windows builds
    sources = [
        "source.vmware-iso.windows",
    ]
    provisioner "powershell" {
        pause_before = "1m"
        elevated_user = var.connection_username
        elevated_password = var.connection_password
        scripts = [
            "scripts/Disable-UAC.ps1" # I re-enable UAC with ansible post deployment
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
        "source.vmware-iso.ubuntu",
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
        "source.vmware-iso.rocky",
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