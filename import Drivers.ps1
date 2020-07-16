If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
Import-Module "C:\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
New-PSDrive -Name "DS001" -PSProvider MDTProvider -Root "D:\DeploymentShare"

MD "DS001:\Out-of-Box Drivers\VMware"
import-mdtdriver -path "DS001:\Out-of-Box Drivers\VMWare" -SourcePath "D:\MDT\Drivers\VMware" -Verbose
MD "DS001:\Out-of-Box Drivers\Sony Vaio VGN-FW31ZJ"
import-mdtdriver -path "DS001:\Out-of-Box Drivers\Sony Vaio VGN-FW31ZJ" -SourcePath "D:\MDT\Drivers\Sony Vaio VGN-FW31ZJ" -Verbose

MD "DS001:\Out-of-Box Drivers\ASUS K50C"
import-mdtdriver -path "DS001:\Out-of-Box Drivers\ASUS K50C" -SourcePath "D:\MDT\Drivers\ASUS K50C" -Verbose