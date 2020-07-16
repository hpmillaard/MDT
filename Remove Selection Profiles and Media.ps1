If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
Import-Module "C:\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
New-PSDrive -Name "DS001" -PSProvider MDTProvider -Root "D:\DeploymentShare"

Function RemoveProfile($Profile){
	Remove-Item "DS001:\Selection Profiles\$Profile"
	Remove-Item "DS001:\Media\$Profile" -ErrorAction SilentlyContinue
	Remove-Item "D:\$Profile" -Force -Recurse -ErrorAction SilentlyContinue
}

RemoveProfile "Server 2016"
RemoveProfile "Server 2019"
RemoveProfile "W10"
RemoveProfile "W10Insider"
