#$Profile = "Server 2016"
#$Profile = "Server 2019"
$Profile = "W10"
#$Profile = "W10Insider"
$X64 = "True"
$X86 = "False"
$ISO = "True"

If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
Import-Module "C:\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
New-PSDrive -Name "DS001" -PSProvider MDTProvider -Root "D:\DeploymentShare"

$Loc = Get-Location
Remove-Item "DS001:\Selection Profiles\$Profile"
Remove-Item "DS001:\Media\$Profile" -ErrorAction SilentlyContinue
Remove-Item "D:\$Profile" -Force -Recurse -ErrorAction SilentlyContinue

$Definition = '<SelectionProfile><Include path="Applications" /><Include path="Operating Systems\' + $Profile + '" /><Include path="Task Sequences\' + $Profile + '" /></SelectionProfile>'
New-Item -Path "DS001:\Selection Profiles" -Name $Profile -Definition $Definition -ReadOnly False
New-Item -Path "DS001:\Media" -enable "True" -Name $Profile -Comments "" -Root "D:\$Profile" -SelectionProfile $Profile -SupportX86 $X86 -SupportX64 $X64 -GenerateISO $ISO -ISOName "$Profile.iso" -Force -Verbose
MD "D:\$Profile\Content\Deploy\Control\"
Copy "$Loc\CustomSettings\Media $Profile.ini" "D:\$Profile\Content\Deploy\Control\CustomSettings.ini" -Force
Copy "$Loc\MDTExitNameToGuid.vbs" "D:\$Profile\Content\Deploy\Control\MDTExitNameToGuid.vbs"
Set-Content -Path "D:\$Profile\Content\Deploy\Control\Bootstrap.ini" -Value "[Settings]`r`nPriority=Default`r`n`r`n[Default]`r`nSkipBDDWelcome=Yes"
Update-MDTMedia DS001:\Media\$Profile
Remove-Item "D:\$Profile\Content\Deploy\Backup" -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item "D:\$Profile\Content\Deploy\Templates" -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item "D:\$Profile\Content\Deploy\Audit.log" -Force -ErrorAction SilentlyContinue
