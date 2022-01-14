# Convert from eval license. Uncomment the datacenter edition vs standard as needed
$findver = get-wmiobject -class win32_operatingsystem | select caption
if ($findver -Match '2019') {
# Convert to Standard license instead of eval
dism /online /set-edition:ServerStandard /productkey:N69G4-B89J2-4G8F4-WWYCC-J464C /accepteula /norestart
# Convert to DC edition from eval
#dism /online /set-edition:ServerDatacenter /productkey:WMDGN-G9PQG-XVVXX-R3X43-63DFG /accepteula /norestart
}
  ElseIf ($findver -Match '2022') {
  # The command to convert Windows Server 2022 Evaluation edition to Standard:
  dism /online /set-edition:serverstandard /productkey:VDYBN-27WPP-V4HQT-9VMD4-VMK7H /accepteula /norestart
  
  # Convert eval instance to Windows Server 2022 Datacenter:
  #dism /online /set-edition:serverdatacenter /productkey:WX4NM-KYWYW-QJJR4-XV3QB-6VM33 /accepteula /norestart
  }

exit 0