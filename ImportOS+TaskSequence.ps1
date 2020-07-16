If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
Import-Module "C:\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
New-PSDrive -Name "DS001" -PSProvider MDTProvider -Root "D:\DeploymentShare"
$WindowsShare = "\\LT-5CG70220KT\d$\HP\OneDrive - VINCI Energies\Software\Windows"
Write-Host $WindowsShare -ForegroundColor Green

Function ToDo(){
#W7
#W8
#W10
W10Insider
#W2008
#W2012
#W2016
#W2019
}

Function MountISO($ISOPath){
	Write-Host "Mounting $ISO" -ForegroundColor Green
	$beforeMount = (Get-Volume).DriveLetter
	$mountresult = Mount-DiskImage $ISO
	$afterMount = (Get-Volume).DriveLetter
	$script:D = $afterMount | Where {$beforeMount -notcontains $_}
	While (!(Test-Path $D':\Sources\install.wim')) {Start-Sleep 2}
	Write-Host "Install.wim found, starting import" -ForegroundColor Green
}

Function DisMountISO($ISOPath){
	$dismountresult = DisMount-DiskImage -ImagePath $ISOPath
	Write-Host "Dismounted $ISO" -ForegroundColor Green
}

Function W7(){
################################################################################################################################
# Windows 7
################################################################################################################################
rd "DS001:\Operating Systems\W7" -Force -Recurse -ErrorAction SilentlyContinue
md "DS001:\Operating Systems\W7" | Out-Null
rd "DS001:\Task Sequences\W7" -Force -Recurse -ErrorAction SilentlyContinue
md "DS001:\Task Sequences\W7" | Out-Null
Set-Location "DS001:\Operating Systems\W7"
################################################################################################################################
$ISO = (get-item filesystem::$WindowsShare\7\*64BIT_English*.ISO).fullname
MountISO($ISO)
import-mdtoperatingsystem -path "DS001:\Operating Systems\W7" -SourcePath $D':\' -DestinationFolder "Windows 7 SP1 x64 EN Enterprise"
ren '*Windows 7 SP1 x64 EN Enterprise*' 'Windows 7 SP1 x64 EN Enterprise'
import-mdttasksequence -path "DS001:\Task Sequences\W7" -Name "Windows 7 x64 EN" -Template "Client.xml" -ID "W7x64EN" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\W7\Windows 7 SP1 x64 EN Enterprise"
DisMountISO($ISO)
################################################################################################################################
$ISO = (get-item filesystem::$WindowsShare\7\*64BIT_Dutch*.ISO).fullname
MountISO($ISO)
import-mdtoperatingsystem -path "DS001:\Operating Systems\W7" -SourcePath $D':\' -DestinationFolder "Windows 7 SP1 x64 NL Enterprise"
ren '*Windows 7 SP1 x64 NL Enterprise*' 'Windows 7 SP1 x64 NL Enterprise'
import-mdttasksequence -path "DS001:\Task Sequences\W7" -Name "Windows 7 x64 NL" -Template "Client.xml" -ID "W7x64NL" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\W7\Windows 7 SP1 x64 NL Enterprise"
DisMountISO($ISO)
################################################################################################################################
$ISO = (get-item filesystem::$WindowsShare\7\*32BIT_English*.ISO).fullname
MountISO($ISO)
import-mdtoperatingsystem -path "DS001:\Operating Systems\W7" -SourcePath $D':\' -DestinationFolder "Windows 7 SP1 x86 EN Enterprise"
ren '*Windows 7 SP1 x86 EN Enterprise*' 'Windows 7 SP1 x86 EN Enterprise'
import-mdttasksequence -path "DS001:\Task Sequences\W7" -Name "Windows 7 x86 EN" -Template "Client.xml" -ID "W7x86EN" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\W7\Windows 7 SP1 x86 EN Enterprise"
DisMountISO($ISO)
################################################################################################################################
$ISO = (get-item filesystem::$WindowsShare\7\*32BIT_Dutch*.ISO).fullname
MountISO($ISO)
import-mdtoperatingsystem -path "DS001:\Operating Systems\W7" -SourcePath $D':\' -DestinationFolder "Windows 7 SP1 x86 NL Enterprise"
ren '*Windows 7 SP1 x86 NL Enterprise*' 'Windows 7 SP1 x86 NL Enterprise'
import-mdttasksequence -path "DS001:\Task Sequences\W7" -Name "Windows 7 x86 NL" -Template "Client.xml" -ID "W7x86NL" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\W7\Windows 7 SP1 x86 NL Enterprise"
DisMountISO($ISO)
}

Function W8(){
################################################################################################################################
# Windows 8
################################################################################################################################
rd "DS001:\Operating Systems\W8" -Force -Recurse -ErrorAction SilentlyContinue
md "DS001:\Operating Systems\W8" | Out-Null
rd "DS001:\Task Sequences\W8" -Force -Recurse -ErrorAction SilentlyContinue
md "DS001:\Task Sequences\W8" | Out-Null
Set-Location "DS001:\Operating Systems\W8"
################################################################################################################################
$ISO = (get-item filesystem::$WindowsShare\8\*64BIT_English*.ISO).fullname
MountISO($ISO)
import-mdtoperatingsystem -path "DS001:\Operating Systems\W8" -SourcePath $D':\' -DestinationFolder "Windows 8.1 x64 EN Enterprise"
ren '*Windows 8.1 x64 EN Enterprise*' 'Windows 8.1 x64 EN Enterprise'
import-mdttasksequence -path "DS001:\Task Sequences\W8" -Name "Windows 8 x64 EN" -Template "Client.xml" -ID "W8x64EN" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\W8\Windows 8.1 x64 EN Enterprise"
DisMountISO($ISO)
################################################################################################################################
$ISO = (get-item filesystem::$WindowsShare\8\*64BIT_Dutch*.ISO).fullname
MountISO($ISO)
import-mdtoperatingsystem -path "DS001:\Operating Systems\W8" -SourcePath $D':\' -DestinationFolder "Windows 8.1 x64 NL Enterprise"
ren '*Windows 8.1 x64 NL Enterprise*' 'Windows 8.1 x64 NL Enterprise'
import-mdttasksequence -path "DS001:\Task Sequences\W8" -Name "Windows 8 x64 NL" -Template "Client.xml" -ID "W8x64NL" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\W8\Windows 8.1 x64 NL Enterprise"
DisMountISO($ISO)
################################################################################################################################
$ISO = (get-item filesystem::$WindowsShare\8\*32BIT_English*.ISO).fullname
MountISO($ISO)
import-mdtoperatingsystem -path "DS001:\Operating Systems\W8" -SourcePath $D':\' -DestinationFolder "Windows 8.1 x86 EN Enterprise"
ren '*Windows 8.1 x86 EN Enterprise*' 'Windows 8.1 x86 EN Enterprise'
import-mdttasksequence -path "DS001:\Task Sequences\W8" -Name "Windows 8 x86 EN" -Template "Client.xml" -ID "W8x86EN" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\W8\Windows 8.1 x86 EN Enterprise"
DisMountISO($ISO)
################################################################################################################################
$ISO = (get-item filesystem::$WindowsShare\8\*32BIT_Dutch*.ISO).fullname
MountISO($ISO)
import-mdtoperatingsystem -path "DS001:\Operating Systems\W8" -SourcePath $D':\' -DestinationFolder "Windows 8.1 x86 NL Enterprise"
ren '*Windows 8.1 x86 NL Enterprise*' 'Windows 8.1 x86 NL Enterprise'
import-mdttasksequence -path "DS001:\Task Sequences\W8" -Name "Windows 8 x86 NL" -Template "Client.xml" -ID "W8x86NL" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\W8\Windows 8.1 x86 NL Enterprise"
DisMountISO($ISO)
}

Function W10(){
################################################################################################################################
# Windows 10
################################################################################################################################
rd "DS001:\Operating Systems\W10" -Force -Recurse -ErrorAction SilentlyContinue
md "DS001:\Operating Systems\W10" | Out-Null
rd "DS001:\Task Sequences\W10" -Force -Recurse -ErrorAction SilentlyContinue
md "DS001:\Task Sequences\W10" | Out-Null
Set-Location "DS001:\Operating Systems\W10"
################################################################################################################################
$ISO = (get-item filesystem::$WindowsShare\10\*64BIT_English*.ISO).fullname
MountISO($ISO)
import-mdtoperatingsystem -path "DS001:\Operating Systems\W10" -SourcePath $D':\' -DestinationFolder "Windows 10 x64 EN"
ren '*Enterprise in Windows 10 x64 EN*' 'Windows 10 x64 EN Enterprise'
#ren '*Enterprise for Remote Sessions in Windows 10 x64 EN*' 'Windows 10 x64 EN Enterprise RDS'
ren '*Pro in Windows 10 x64 EN*' 'Windows 10 x64 EN Pro'
del '*in Windows 10 x64 EN*'
import-mdttasksequence -path "DS001:\Task Sequences\W10" -Name "Windows 10 x64 EN Enterprise" -Template "Client.xml" -ID "W10x64ENENT" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\W10\Windows 10 x64 EN Enterprise"
#import-mdttasksequence -path "DS001:\Task Sequences\W10" -Name "Windows 10 x64 EN Enterprise RDS" -Template "Client.xml" -ID "W10x64ENENTRDS" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\W10\Windows 10 x64 EN Enterprise RDS"
import-mdttasksequence -path "DS001:\Task Sequences\W10" -Name "Windows 10 x64 EN Pro" -Template "Client.xml" -ID "W10x64ENPRO" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\W10\Windows 10 x64 EN Pro"
DisMountISO($ISO)
################################################################################################################################
$ISO = (get-item filesystem::$WindowsShare\10\*64BIT_Dutch*.ISO).fullname
MountISO($ISO)
import-mdtoperatingsystem -path "DS001:\Operating Systems\W10" -SourcePath $D':\' -DestinationFolder "Windows 10 x64 NL"
ren '*Enterprise in Windows 10 x64 NL*' 'Windows 10 x64 NL Enterprise'
#ren '*Enterprise for Remote Sessions in Windows 10 x64 NL*' 'Windows 10 x64 NL Enterprise RDS'
ren '*Pro in Windows 10 x64 NL*' 'Windows 10 x64 NL Pro'
del '*in Windows 10 x64 NL*'
import-mdttasksequence -path "DS001:\Task Sequences\W10" -Name "Windows 10 x64 NL Enterprise" -Template "Client.xml" -ID "W10x64NLENT" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\W10\Windows 10 x64 NL Enterprise"
#import-mdttasksequence -path "DS001:\Task Sequences\W10" -Name "Windows 10 x64 NL Enterprise RDS" -Template "Client.xml" -ID "W10x64NLENTRDS" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\W10\Windows 10 x64 NL Enterprise RDS"
import-mdttasksequence -path "DS001:\Task Sequences\W10" -Name "Windows 10 x64 NL Pro" -Template "Client.xml" -ID "W10x64NLPRO" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\W10\Windows 10 x64 NL Pro"
DisMountISO($ISO)
################################################################################################################################
$ISO = (get-item filesystem::$WindowsShare\10\*32BIT_English*.ISO).fullname
MountISO($ISO)
import-mdtoperatingsystem -path "DS001:\Operating Systems\W10" -SourcePath $D':\' -DestinationFolder "Windows 10 x86 EN"
ren '*Enterprise in Windows 10 x86 EN*' 'Windows 10 x86 EN Enterprise'
ren '*Pro in Windows 10 x86 EN*' 'Windows 10 x86 EN Pro'
del '*in Windows 10 x86 EN*'
import-mdttasksequence -path "DS001:\Task Sequences\W10" -Name "Windows 10 x86 EN Enterprise" -Template "Client.xml" -ID "W10x86ENENT" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\W10\Windows 10 x86 EN Enterprise"
import-mdttasksequence -path "DS001:\Task Sequences\W10" -Name "Windows 10 x86 EN Pro" -Template "Client.xml" -ID "W10x86ENPRO" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\W10\Windows 10 x86 EN Pro"
DisMountISO($ISO)
################################################################################################################################
$ISO = (get-item filesystem::$WindowsShare\10\*32BIT_Dutch*.ISO).fullname
MountISO($ISO)
import-mdtoperatingsystem -path "DS001:\Operating Systems\W10" -SourcePath $D':\' -DestinationFolder "Windows 10 x86 NL"
ren '*Enterprise in Windows 10 x86 NL*' 'Windows 10 x86 NL Enterprise'
ren '*Pro in Windows 10 x86 NL*' 'Windows 10 x86 NL Pro'
del '*in Windows 10 x86 NL*'
import-mdttasksequence -path "DS001:\Task Sequences\W10" -Name "Windows 10 x86 NL Enterprise" -Template "Client.xml" -ID "W10x86NLENT" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\W10\Windows 10 x86 NL Enterprise"
import-mdttasksequence -path "DS001:\Task Sequences\W10" -Name "Windows 10 x86 NL Pro" -Template "Client.xml" -ID "W10x86NLPRO" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\W10\Windows 10 x86 NL Pro"
DisMountISO($ISO)
}

Function W10Insider(){
################################################################################################################################
# Windows 10 Insider
################################################################################################################################
rd "DS001:\Operating Systems\W10Insider" -Force -Recurse -ErrorAction SilentlyContinue
md "DS001:\Operating Systems\W10Insider" | Out-Null
rd "DS001:\Task Sequences\W10Insider" -Force -Recurse -ErrorAction SilentlyContinue
md "DS001:\Task Sequences\W10Insider" | Out-Null
Set-Location "DS001:\Operating Systems\W10Insider"
################################################################################################################################
$ISO = (get-item filesystem::$WindowsShare\10\*RELEASE*X64*EN-US.ISO).fullname
MountISO($ISO)
import-mdtoperatingsystem -path "DS001:\Operating Systems\W10Insider" -SourcePath $D':\' -DestinationFolder "Windows 10 x64 EN Insider"
ren 'Windows 10 Enterprise in Windows 10 x64 EN Insider*' 'Windows 10 x64 EN Enterprise Insider'
ren 'Windows 10 Enterprise for Remote Sessions in Windows 10 x64 EN Insider*' 'Windows 10 x64 EN Enterprise RDS Insider'
ren 'Windows 10 Pro in Windows 10 x64 EN Insider*' 'Windows 10 x64 EN Pro Insider'
del '*in Windows 10 x64 EN Insider*'
Write-Host "Other Versions removed, start Task Sequence Import" -ForegroundColor Green
import-mdttasksequence -path "DS001:\Task Sequences\W10Insider" -Name "Windows 10 x64 EN Enterprise Insider" -Template "Client.xml" -ID "W10x64ENENTInsider" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\W10Insider\Windows 10 x64 EN Enterprise Insider"
import-mdttasksequence -path "DS001:\Task Sequences\W10Insider" -Name "Windows 10 x64 EN Enterprise RDS Insider" -Template "Client.xml" -ID "W10x64ENENTRDSInsider" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\W10Insider\Windows 10 x64 EN Enterprise RDS Insider"
import-mdttasksequence -path "DS001:\Task Sequences\W10Insider" -Name "Windows 10 x64 EN Pro Insider" -Template "Client.xml" -ID "W10x64ENPROInsider" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\W10Insider\Windows 10 x64 EN Pro Insider"
Write-Host "Task Sequences Imported" -ForegroundColor Green
DisMountISO($ISO)
################################################################################################################################
$ISO = (get-item filesystem::$WindowsShare\10\*RELEASE*X64*NL-NL.ISO).fullname
MountISO($ISO)
import-mdtoperatingsystem -path "DS001:\Operating Systems\W10Insider" -SourcePath $D':\' -DestinationFolder "Windows 10 x64 NL Insider"
ren 'Windows 10 Enterprise in Windows 10 x64 NL Insider*' 'Windows 10 x64 NL Enterprise Insider'
ren 'Windows 10 Enterprise for Remote Sessions in Windows 10 x64 NL Insider*' 'Windows 10 x64 NL Enterprise RDS Insider'
ren 'Windows 10 Pro in Windows 10 x64 NL Insider*' 'Windows 10 x64 NL Pro Insider'
del '*in Windows 10 x64 NL Insider*'
Write-Host "Other Versions removed, start Task Sequence Import" -ForegroundColor Green
import-mdttasksequence -path "DS001:\Task Sequences\W10Insider" -Name "Windows 10 x64 NL Enterprise Insider" -Template "Client.xml" -ID "W10x64NLENTInsider" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\W10Insider\Windows 10 x64 NL Enterprise Insider"
import-mdttasksequence -path "DS001:\Task Sequences\W10Insider" -Name "Windows 10 x64 NL Enterprise RDS Insider" -Template "Client.xml" -ID "W10x64NLENTRDSInsider" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\W10Insider\Windows 10 x64 NL Enterprise RDS Insider"
import-mdttasksequence -path "DS001:\Task Sequences\W10Insider" -Name "Windows 10 x64 NL Pro Insider" -Template "Client.xml" -ID "W10x64NLPROInsider" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\W10Insider\Windows 10 x64 NL Pro Insider"
Write-Host "Task Sequences Imported" -ForegroundColor Green
DisMountISO($ISO)
################################################################################################################################
$ISO = (get-item filesystem::$WindowsShare\10\*RELEASE*X86*EN-US.ISO).fullname
MountISO($ISO)
import-mdtoperatingsystem -path "DS001:\Operating Systems\W10Insider" -SourcePath $D':\' -DestinationFolder "Windows 10 x86 EN Insider"
ren 'Windows 10 Enterprise in Windows 10 x86 EN Insider*' 'Windows 10 x86 EN Enterprise Insider'
ren 'Windows 10 Pro in Windows 10 x86 EN Insider*' 'Windows 10 x86 EN Pro Insider'
del '*in Windows 10 x86 EN Insider*'
Write-Host "Other Versions removed, start Task Sequence Import" -ForegroundColor Green
import-mdttasksequence -path "DS001:\Task Sequences\W10Insider" -Name "Windows 10 x86 EN Enterprise Insider" -Template "Client.xml" -ID "W10x86ENENTInsider" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\W10Insider\Windows 10 x86 EN Enterprise Insider"
#import-mdttasksequence -path "DS001:\Task Sequences\W10Insider" -Name "Windows 10 x86 EN Enterprise RDS Insider" -Template "Client.xml" -ID "W10x86ENENTRDSInsider" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\W10Insider\Windows 10 x86 EN Enterprise RDS Insider"
import-mdttasksequence -path "DS001:\Task Sequences\W10Insider" -Name "Windows 10 x86 EN Pro Insider" -Template "Client.xml" -ID "W10x86ENPROInsider" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\W10Insider\Windows 10 x86 EN Pro Insider"
Write-Host "Task Sequences Imported" -ForegroundColor Green
DisMountISO($ISO)
################################################################################################################################
$ISO = (get-item filesystem::$WindowsShare\10\*RELEASE*X86*NL-NL.ISO).fullname
MountISO($ISO)
import-mdtoperatingsystem -path "DS001:\Operating Systems\W10Insider" -SourcePath $D':\' -DestinationFolder "Windows 10 x86 NL Insider"
ren 'Windows 10 Enterprise in Windows 10 x86 NL Insider*' 'Windows 10 x86 NL Enterprise Insider'
ren 'Windows 10 Pro in Windows 10 x86 NL Insider*' 'Windows 10 x86 NL Pro Insider'
del '*in Windows 10 x86 NL Insider*'
Write-Host "Other Versions removed, start Task Sequence Import" -ForegroundColor Green
import-mdttasksequence -path "DS001:\Task Sequences\W10Insider" -Name "Windows 10 x86 NL Enterprise Insider" -Template "Client.xml" -ID "W10x86NLENTInsider" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\W10Insider\Windows 10 x86 NL Enterprise Insider"
#import-mdttasksequence -path "DS001:\Task Sequences\W10Insider" -Name "Windows 10 x86 NL Enterprise RDS Insider" -Template "Client.xml" -ID "W10x86NLENTRDSInsider" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\W10Insider\Windows 10 x86 NL Enterprise RDS Insider"
import-mdttasksequence -path "DS001:\Task Sequences\W10Insider" -Name "Windows 10 x86 NL Pro Insider" -Template "Client.xml" -ID "W10x86NLPROInsider" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\W10Insider\Windows 10 x86 NL Pro Insider"
Write-Host "Task Sequences Imported" -ForegroundColor Green
DisMountISO($ISO)
################################################################################################################################
}

Function W2008(){
################################################################################################################################
# Windows 2008 R2
################################################################################################################################
rd "DS001:\Operating Systems\Server 2008" -Force -Recurse -ErrorAction SilentlyContinue
md "DS001:\Operating Systems\Server 2008" | Out-Null
rd "DS001:\Task Sequences\Server 2008" -Force -Recurse -ErrorAction SilentlyContinue
md "DS001:\Task Sequences\Server 2008" | Out-Null
Set-Location "DS001:\Operating Systems\Server 2008"
################################################################################################################################
$ISO = (get-item filesystem::$WindowsShare\2008\*2008*.ISO).fullname
MountISO($ISO)
import-mdtoperatingsystem -path "DS001:\Operating Systems\Server 2008" -SourcePath $D':\' -DestinationFolder "Windows Server 2008 R2" 
ren '*SERVERDATACENTER in Windows Server 2008 R2*' 'Windows Server 2008 R2 DataCenter'
ren '*SERVERDATACENTERCORE in Windows Server 2008 R2*' 'Windows Server 2008 R2 DataCenterCore'
ren '*SERVERENTERPRISE in Windows Server 2008 R2*' 'Windows Server 2008 R2 Enterprise'
ren '*SERVERENTERPRISECORE in Windows Server 2008 R2*' 'Windows Server 2008 R2 EnterpriseCore'
ren '*SERVERSTANDARD in Windows Server 2008 R2*' 'Windows Server 2008 R2 Standard'
ren '*SERVERSTANDARDCORE in Windows Server 2008 R2*' 'Windows Server 2008 R2 StandardCore'
ren '*SERVERWEB in Windows Server 2008 R2*' 'Windows Server 2008 R2 Web'
ren '*SERVERWEBCORE in Windows Server 2008 R2*' 'Windows Server 2008 R2 WebCore'
import-mdttasksequence -path "DS001:\Task Sequences\Server 2008" -Name "Windows 2008 DataCenter" -Template "Server.xml" -ID "W2008DC" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Server 2008\Windows Server 2008 R2 DATACENTER"
import-mdttasksequence -path "DS001:\Task Sequences\Server 2008" -Name "Windows 2008 DataCenter Core" -Template "Server.xml" -ID "W2008DCCORE" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Server 2008\Windows Server 2008 R2 DATACENTERCORE"
import-mdttasksequence -path "DS001:\Task Sequences\Server 2008" -Name "Windows 2008 Enterprise" -Template "Server.xml" -ID "W2008ENT" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Server 2008\Windows Server 2008 R2 ENTERPRISE"
import-mdttasksequence -path "DS001:\Task Sequences\Server 2008" -Name "Windows 2008 Enterprise Core" -Template "Server.xml" -ID "W2008ENTCORE" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Server 2008\Windows Server 2008 R2 ENTERPRISECORE"
import-mdttasksequence -path "DS001:\Task Sequences\Server 2008" -Name "Windows 2008 Standard" -Template "Server.xml" -ID "W2008STD" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Server 2008\Windows Server 2008 R2 STANDARD"
import-mdttasksequence -path "DS001:\Task Sequences\Server 2008" -Name "Windows 2008 Standard Core" -Template "Server.xml" -ID "W2008STDCORE" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Server 2008\Windows Server 2008 R2 STANDARDCORE"
import-mdttasksequence -path "DS001:\Task Sequences\Server 2008" -Name "Windows 2008 Web" -Template "Server.xml" -ID "W2008WEB" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Server 2008\Windows Server 2008 R2 WEB"
import-mdttasksequence -path "DS001:\Task Sequences\Server 2008" -Name "Windows 2008 Web Core" -Template "Server.xml" -ID "W2008WEBCORE" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Server 2008\Windows Server 2008 R2 WEBCORE"
DisMountISO($ISO)
}

Function W2012(){
################################################################################################################################
# Windows 2012 R2
################################################################################################################################
rd "DS001:\Operating Systems\Server 2012" -Force -Recurse -ErrorAction SilentlyContinue
md "DS001:\Operating Systems\Server 2012" | Out-Null
rd "DS001:\Task Sequences\Server 2012" -Force -Recurse -ErrorAction SilentlyContinue
md "DS001:\Task Sequences\Server 2012" | Out-Null
Set-Location "DS001:\Operating Systems\Server 2012"
################################################################################################################################
$ISO = (get-item filesystem::$WindowsShare\2012\*2012*.ISO).fullname
MountISO($ISO)
import-mdtoperatingsystem -path "DS001:\Operating Systems\Server 2012" -SourcePath $D':\' -DestinationFolder "Windows Server 2012 R2" 
ren '*SERVERDATACENTER in Windows Server 2012 R2*' 'Windows Server 2012 R2 DataCenter'
ren '*SERVERDATACENTERCORE in Windows Server 2012 R2*' 'Windows Server 2012 R2 DataCenterCore'
ren '*SERVERSTANDARD in Windows Server 2012 R2*' 'Windows Server 2012 R2 Standard'
ren '*SERVERSTANDARDCORE in Windows Server 2012 R2*' 'Windows Server 2012 R2 StandardCore'
import-mdttasksequence -path "DS001:\Task Sequences\Server 2012" -Name "Windows 2012 DataCenter" -Template "Server.xml" -ID "W2012DC" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Server 2012\Windows Server 2012 R2 DATACENTER"
import-mdttasksequence -path "DS001:\Task Sequences\Server 2012" -Name "Windows 2012 DataCenterCore" -Template "Server.xml" -ID "W2012DCCORE" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Server 2012\Windows Server 2012 R2 DATACENTERCORE"
import-mdttasksequence -path "DS001:\Task Sequences\Server 2012" -Name "Windows 2012 Standard" -Template "Server.xml" -ID "W2012STD" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Server 2012\Windows Server 2012 R2 STANDARD"
import-mdttasksequence -path "DS001:\Task Sequences\Server 2012" -Name "Windows 2012 StandardCore" -Template "Server.xml" -ID "W2012STDCORE" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Server 2012\Windows Server 2012 R2 STANDARDCORE"
DisMountISO($ISO)
}

Function W2016(){
################################################################################################################################
# Windows 2016
################################################################################################################################
rd "DS001:\Operating Systems\Server 2016" -Force -Recurse -ErrorAction SilentlyContinue
md "DS001:\Operating Systems\Server 2016" | Out-Null
rd "DS001:\Task Sequences\Server 2016" -Force -Recurse -ErrorAction SilentlyContinue
md "DS001:\Task Sequences\Server 2016" | Out-Null
Set-Location "DS001:\Operating Systems\Server 2016"
################################################################################################################################
$ISO = (get-item filesystem::$WindowsShare\2016\*CORE*2016*.ISO).fullname
MountISO($ISO)
import-mdtoperatingsystem -path "DS001:\Operating Systems\Server 2016" -SourcePath $D':\' -DestinationFolder "Windows Server 2016" 
ren '*SERVERDATACENTER in Windows Server 2016*' 'Windows Server 2016 DataCenter'
ren '*SERVERDATACENTERCORE in Windows Server 2016*' 'Windows Server 2016 DataCenterCore'
ren '*SERVERSTANDARD in Windows Server 2016*' 'Windows Server 2016 Standard'
ren '*SERVERSTANDARDCORE in Windows Server 2016*' 'Windows Server 2016 StandardCore'
import-mdttasksequence -path "DS001:\Task Sequences\Server 2016" -Name "Windows 2016 DataCenter" -Template "Server.xml" -ID "W2016DC" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Server 2016\Windows Server 2016 DATACENTER"
import-mdttasksequence -path "DS001:\Task Sequences\Server 2016" -Name "Windows 2016 DataCenterCore" -Template "Server.xml" -ID "W2016DCCORE" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Server 2016\Windows Server 2016 DATACENTERCORE"
import-mdttasksequence -path "DS001:\Task Sequences\Server 2016" -Name "Windows 2016 Standard" -Template "Server.xml" -ID "W2016STD" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Server 2016\Windows Server 2016 STANDARD"
import-mdttasksequence -path "DS001:\Task Sequences\Server 2016" -Name "Windows 2016 StandardCore" -Template "Server.xml" -ID "W2016STDCORE" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Server 2016\Windows Server 2016 STANDARDCORE"
DisMountISO($ISO)
}

Function W2019(){
################################################################################################################################
# Windows 2019
################################################################################################################################
rd "DS001:\Operating Systems\Server 2019" -Force -Recurse -ErrorAction SilentlyContinue
md "DS001:\Operating Systems\Server 2019" | Out-Null
rd "DS001:\Task Sequences\Server 2019" -Force -Recurse -ErrorAction SilentlyContinue
md "DS001:\Task Sequences\Server 2019" | Out-Null
Set-Location "DS001:\Operating Systems\Server 2019"
################################################################################################################################
$ISO = (get-item filesystem::$WindowsShare\2019\*2019*.ISO).fullname
MountISO($ISO)
import-mdtoperatingsystem -path "DS001:\Operating Systems\Server 2019" -SourcePath $D':\' -DestinationFolder "Windows Server 2019" 
ren '*SERVERDATACENTER in Windows Server 2019*' 'Windows Server 2019 DataCenter'
ren '*SERVERDATACENTERCORE in Windows Server 2019*' 'Windows Server 2019 DataCenterCore'
ren '*SERVERSTANDARD in Windows Server 2019*' 'Windows Server 2019 Standard'
ren '*SERVERSTANDARDCORE in Windows Server 2019*' 'Windows Server 2019 StandardCore'
import-mdttasksequence -path "DS001:\Task Sequences\Server 2019" -Name "Windows 2019 DataCenter" -Template "Server.xml" -ID "W2019DC" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Server 2019\Windows Server 2019 DATACENTER"
import-mdttasksequence -path "DS001:\Task Sequences\Server 2019" -Name "Windows 2019 DataCenterCore" -Template "Server.xml" -ID "W2019DCCORE" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Server 2019\Windows Server 2019 DATACENTERCORE"
import-mdttasksequence -path "DS001:\Task Sequences\Server 2019" -Name "Windows 2019 Standard" -Template "Server.xml" -ID "W2019STD" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Server 2019\Windows Server 2019 STANDARD"
import-mdttasksequence -path "DS001:\Task Sequences\Server 2019" -Name "Windows 2019 StandardCore" -Template "Server.xml" -ID "W2019STDCORE" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Server 2019\Windows Server 2019 STANDARDCORE"
DisMountISO($ISO)
}

ToDo
pause