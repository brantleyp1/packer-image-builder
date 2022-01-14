################
#
# This isn't used currently, but if/when a hardening process is needed, this script will be required
#
################

# Ensuring the components are there and not messing around.
If(-not(Get-InstalledModule PSDesiredStateConfiguration -ErrorAction silentlycontinue)){
    Install-Module PSDesiredStateConfiguration -Confirm:$False -Force
}
If(-not(Get-InstalledModule AuditPolicyDsc -ErrorAction silentlycontinue)){
    Install-Module AuditPolicyDsc -Confirm:$False -Force
}
If(-not(Get-InstalledModule SecurityPolicyDsc -ErrorAction silentlycontinue)){
    Install-Module SecurityPolicyDsc -Confirm:$False -Force
}
If(-not(Get-InstalledModule NetworkingDsc -ErrorAction silentlycontinue)){
    Install-Module NetworkingDsc -Confirm:$False -Force
}
