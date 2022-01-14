################
#
# not used at this time. needed if/when a hardening process is needed
#
################

$file = 'C:\Program Files\WindowsPowerShell\Modules\PSDesiredStateConfiguration\2.0.5\PSDesiredStateConfiguration.psd1'

(Get-content $file) | Foreach-Object {$_ -replace "^PowerShellVersion = '6.1'", "PowerShellVersion = '5'"} | Set-Content $file