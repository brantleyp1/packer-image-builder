variable "vcenter_server" {
    description = "vCenter server to build the VM on"
    default     = "virtualcenter.example.net"
}
variable "vcenter_username" {
    description = "Username to authenticate to vCenter"
    default     = "packer@vsphere.local"
}
variable "vcenter_password" {
    description = "Password to authenticate to vCenter"
    default     = "SomeOtherPassword"
}
variable "vcenter_connection" {
    description = "true/false insecure_connection to vcenter"
    default     = "true"
}

  
variable "vcenter_cluster" {
    description = "Cluster is required if host is not supplied"
    default = "cluster_1"
}
variable "vcenter_datacenter" {
    description = "which datacenter to use?"
    default = "mainDC"
}
variable "vcenter_host" {
    description = "host is required if cluster is not supplied"
    default = "10.1.7.14"
}
variable "vcenter_content_library" {
    description = "Content Library used for storing final template"
    default = "Seed"
}
variable "vcenter_datastore" {
    description = "Datastore used for building as well as content library"
    default = "NFSDatastore"
}
/*
variable "vcenter_folder" {
    description = "The vcenter folder to store the template"
}
*/
variable "connection_username" {
    description = "username to connect to vm during build process"
    default = "admin"
}
variable "connection_password" {
    description = "password to connect to vm during build process"
    default = "SuperSecretPassword"
}
variable "vm_hardware_version" {
    default = "18"
}
variable "vm_hardware_version_local" {
    default = "18"
}
variable "iso_checksum" {}
variable "os_version" {}
variable "os_iso_path" {}
variable "guest_os_type" {}
variable "guest_os_type_local" {
    default = ""
}
variable "root_disk_size" {
    default = 51200
}
variable "nic_type" {
    default = "vmxnet3"
}
variable "vm_network" {
    default = "VM Network"
}
variable "num_cpu" {
    default = 4
}
variable "num_cores" {
    default = 1
}
variable "convert_to_template" {
    description = "convert_to_template needs to be false to import to content library"
    default = "false"
}
variable "vm_ram" {
    default = 4096
}
variable "os_family" {
    description = "OS Family builds the paths needed for packer"
    default = ""
}
variable "os_iso_url" {
    description = "The download url for the ISO"
    default = ""
}
variable "boot_command" {} #TODO: Figure out a better way to handle this
variable "output_directory" {
    description = "For vmware(local) builds, a path to store the final product"
    default = "~/tmp"
}