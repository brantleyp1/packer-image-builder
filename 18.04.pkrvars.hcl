os_version = "1804"
os_family = "ubuntu"
guest_os_type = "ubuntu64Guest"
guest_os_type_local = "ubuntu-64"
os_iso_path = "Seed/ubuntu-18.04.6-server-amd64/ubuntu-18.04.6-server-amd64.iso"
os_iso_url = "/some/local/path/ubuntu-18.04.6-server-amd64.iso"
iso_checksum = "6c647b1ab4318e8c560d5748f908e108be654bad1e165f7cf4f3c1fc43995934"
boot_command = [
  "<wait><enter><wait><f6><esc><wait>",
  "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
  "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
  "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
  "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
  "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
  "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
  "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
  "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
  "<bs><bs><bs>",
  "/install/vmlinuz",
  " initrd=/install/initrd.gz",
  " priority=critical",
  " locale=en_US.UTF-8",
  " keyboard=us",
  " file=/media/preseed.cfg",
  "<enter>"
]