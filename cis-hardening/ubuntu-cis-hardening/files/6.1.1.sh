#!/bin/bash
# Author: Ali Saleh Baker (alivlive@gmail.com)
# Github: https://github.com/alivx/
# Skype: alivxlive
# 6.1.1.sh (c) 2020
# Desc:  6.1.1 Audit system file permissions (Manual)
# Created: 2020-09-17T14:00:49.313Z
# Note: Correct any discrepancies found and rerun the audit until output is clean or risk is mitigated or accepted.
listOfPackages=($(dpkg -l | sed 1,5d | awk '{print $2}' | paste -s))
for package in "${listOfPackages[@]}"; do
    value=$(dpkg --verify ${package} | egrep -o "[S]|[M]|[5]|[D]|[L]|[U]|[G]|[T]")
    if [[ ${value} == S ]]; then
        echo "${package} | S | File size differs."
    elif [[ ${value} == M ]]; then
        echo "${package} | M | File mode differs (includes permissions and file type)."
    elif [[ ${value} == 5 ]]; then
        echo "${package} | 5 | The MD5 checksum differs."
    elif [[ ${value} == D ]]; then
        echo "${package} | D | The major and minor version numbers differ on a device file."
    elif [[ ${value} == L ]]; then
        echo "${package} | L | A mismatch occurs in a link."
    elif [[ ${value} == U ]]; then
        echo "${package} | U | The file ownership differs."
    elif [[ ${value} == G ]]; then
        echo "${package} | G | The file group owner differs."
    elif [[ ${value} == T ]]; then
        echo "${package} | T | The file time (mtime) differs."
    else
        true
    fi
done
