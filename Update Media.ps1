If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
Import-Module "C:\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
New-PSDrive -Name "DS001" -PSProvider MDTProvider -Root "D:\DeploymentShare"

Update-MDTMedia "DS001:\Media\W10"
Update-MDTMedia "DS001:\Media\W10Insider"
Update-MDTMedia "DS001:\Media\Server 2016"
Update-MDTMedia "DS001:\Media\Server 2019"

Remove-Item "D:\*\Content\Deploy\Backup" -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item "D:\*\Content\Deploy\Templates" -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item "D:\*\Content\Deploy\Audit.log" -Force -ErrorAction SilentlyContinue

pause