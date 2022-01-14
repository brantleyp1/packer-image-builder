#!/bin/bash
if command -v nmcli >/dev/null 2>&1; then
    nmcli radio all | grep -Eq '\s*\S+\s+disabled\s+\S+\s+disabled\b' && echo "Wireless is not enabled" || nmcli radio all
elif [ -n "$(find /sys/class/net/*/ -type d -name wireless)" ]; then
    t=0
    drivers=$(for driverdir in $(find /sys/class/net/*/ -type d -name wireless | xargs -0 dirname); do basename "$(readlink -f "$driverdir"/device/driver)"; done | sort -u)
    for dm in $drivers; do
        if grep -Eq "^\s*install\s+$dm\s+/bin/(true|false)" /etc/modprobe.d/*.conf; then
            /bin/true
        else
            echo "$dm is not disabled"
            t=1
        fi
    done
    [[ $t -eq 0 ]] && echo "Wireless is not enabled"
else
    echo "Wireless is not enabled"
fi
