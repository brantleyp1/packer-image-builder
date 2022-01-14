os_version = "8"
os_family = "rocky"
guest_os_type = "centos8_64Guest"
os_iso_path = "Seed/Rocky-8.4-x86_64-minimal/Rocky-8.4-x86_64-minimal.iso"
os_iso_url = "/some/local/path/Rocky-8.4-x86_64-minimal.iso"
iso_checksum = "0de5f12eba93e00fefc06cdb0aa4389a0972a4212977362ea18bde46a1a1aa4f"
boot_command = [
  "<tab>",
  " text inst.ks=hd:LABEL=cidata:ks.cfg<enter><wait>"
]