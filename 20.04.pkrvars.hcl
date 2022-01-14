os_version = "2004"
os_family = "ubuntu"
guest_os_type = "ubuntu64Guest"
guest_os_type_local = "ubuntu-64"
os_iso_path = "Seed/ubuntu-20.04.2-live-server-amd64/ubuntu-20.04.2-live-server-amd64.iso"
os_iso_url = "/some/local/path/ubuntu-20.04.2-live-server-amd64.iso"
iso_checksum = "d1f2bf834bbe9bb43faf16f9be992a6f3935e65be0edece1dee2aa6eb1767423"
boot_command = [
  "<enter><enter><f6><esc><wait>",
  "autoinstall ip=dhcp ds=nocloud;<enter><wait>",
  "<wait><enter>"
]