#!/bin/bash
grep -Els "^\s*net\.ipv4\.ip_forward\s*=\s*1" /etc/sysctl.conf /etc/sysctl.d/*.conf /usr/lib/sysctl.d/*.conf /run/sysctl.d/*.conf | while read filename; do sed -ri "s/^\s*(net\.ipv4\.ip_forward\s*)(=)(\s*\S+\b).*$/#*REMOVED* \1/" $filename; done
sysctl -w net.ipv4.ip_forward=0
sysctl -w net.ipv4.route.flush=1