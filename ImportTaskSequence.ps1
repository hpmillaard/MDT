If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
Import-Module "C:\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"

New-PSDrive -Name "DS001" -PSProvider MDTProvider -Root "D:\DeploymentShare"

import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 7 x64 EN" -Template "Client.xml" -ID "W7x64EN" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows 7 SP1 x64 EN Enterprise"
import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 7 x64 NL" -Template "Client.xml" -ID "W7x64NL" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows 7 SP1 x64 NL Enterprise"
import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 7 x86 EN" -Template "Client.xml" -ID "W7x86EN" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows 7 SP1 x86 EN Enterprise"
import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 7 x86 NL" -Template "Client.xml" -ID "W7x86NL" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows 7 SP1 x86 NL Enterprise"

import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 8 x64 EN" -Template "Client.xml" -ID "W8x64EN" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows 8.1 x64 EN Enterprise"
import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 8 x64 NL" -Template "Client.xml" -ID "W8x64NL" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows 8.1 x64 NL Enterprise"
import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 8 x86 EN" -Template "Client.xml" -ID "W8x86EN" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows 8.1 x86 EN Enterprise"
import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 8 x86 NL" -Template "Client.xml" -ID "W8x86NL" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows 8.1 x86 NL Enterprise"

import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 10 x64 EN Enterprise" -Template "Client.xml" -ID "W10x64ENENT" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows 10 x64 EN Enterprise"
import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 10 x64 NL Enterprise" -Template "Client.xml" -ID "W10x64NLENT" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows 10 x64 NL Enterprise"
import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 10 x86 EN Enterprise" -Template "Client.xml" -ID "W10x86ENENT" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows 10 x86 EN Enterprise"
import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 10 x86 NL Enterprise" -Template "Client.xml" -ID "W10x86NLENT" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows 10 x86 NL Enterprise"

import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 10 x64 EN Pro" -Template "Client.xml" -ID "W10x64ENPro" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows 10 x64 EN Pro"
import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 10 x64 NL Pro" -Template "Client.xml" -ID "W10x64NLPro" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows 10 x64 NL Pro"
import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 10 x86 EN Pro" -Template "Client.xml" -ID "W10x86ENPro" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows 10 x86 EN Pro"
import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 10 x86 NL Pro" -Template "Client.xml" -ID "W10x86NLPro" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows 10 x86 NL Pro"

import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 2008 DataCenter" -Template "Server.xml" -ID "W2008DC" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows Server 2008 R2 DATACENTER"
import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 2008 DataCenter Core" -Template "Server.xml" -ID "W2008DCCORE" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows Server 2008 R2 DATACENTERCORE"
import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 2008 Enterprise" -Template "Server.xml" -ID "W2008ENT" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows Server 2008 R2 ENTERPRISE"
import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 2008 Enterprise Core" -Template "Server.xml" -ID "W2008ENTCORE" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows Server 2008 R2 ENTERPRISECORE"
import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 2008 Standard" -Template "Server.xml" -ID "W2008STD" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows Server 2008 R2 STANDARD"
import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 2008 Standard Core" -Template "Server.xml" -ID "W2008STDCORE" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows Server 2008 R2 STANDARDCORE"
import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 2008 Web" -Template "Server.xml" -ID "W2008WEB" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows Server 2008 R2 WEB"
import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 2008 Web Core" -Template "Server.xml" -ID "W2008WEBCORE" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows Server 2008 R2 WEBCORE"

import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 2012 DataCenter" -Template "Server.xml" -ID "W2012DC" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows Server 2012 R2 DATACENTER"
import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 2012 DataCenterCore" -Template "Server.xml" -ID "W2012DCCORE" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows Server 2012 R2 DATACENTERCORE"
import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 2012 Standard" -Template "Server.xml" -ID "W2012STD" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows Server 2012 R2 STANDARD"
import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 2012 StandardCore" -Template "Server.xml" -ID "W2012STDCORE" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows Server 2012 R2 STANDARDCORE"

import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 2016 DataCenter" -Template "Server.xml" -ID "W2016DC" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows Server 2016 DATACENTER"
import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 2016 DataCenterCore" -Template "Server.xml" -ID "W2016DCCORE" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows Server 2016 DATACENTERCORE"
import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 2016 Standard" -Template "Server.xml" -ID "W2016STD" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows Server 2016 STANDARD"
import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 2016 StandardCore" -Template "Server.xml" -ID "W2016STDCORE" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows Server 2016 STANDARDCORE"

import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 2019 DataCenter" -Template "Server.xml" -ID "W2019DC" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows Server 2019 DATACENTER"
import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 2019 DataCenterCore" -Template "Server.xml" -ID "W2019DCCORE" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows Server 2019 DATACENTERCORE"
import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 2019 Standard" -Template "Server.xml" -ID "W2019STD" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows Server 2019 STANDARD"
import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 2019 StandardCore" -Template "Server.xml" -ID "W2019STDCORE" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows Server 2019 STANDARDCORE"
