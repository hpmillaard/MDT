$DeploymentShare = "D:\MDT\DeploymentShare"
$Source = "D:\MDT\Apps"
$Import = $false

If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit}

#######
# De regels hieronder bepalen de logica van het script
#######
Import-Module "C:\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
New-PSDrive -Name "DS001" -PSProvider MDTProvider -Root $DeploymentShare
Function ImportApp(){
	param([Parameter(Mandatory=$true)][string]$Command,[Parameter(Mandatory=$true)][string]$Naam,[Parameter(Mandatory=$False)]$Reboot)
	$location = Get-Location
	Set-Location "DS001:\Applications"
	If (Test-Path $Naam){If ($Naam -notmatch "VDA" -and $Naam -notmatch "XenConvert"){Remove-Item $Naam -Recurse -Force}}
	If ($Import) {
		Import-MDTApplication -Name $Naam -ShortName $Naam -enable "True" -CommandLine $Command -WorkingDirectory ".\Applications\$Naam" -ApplicationSourcePath (Join-Path $Source $Naam) -DestinationFolder $Naam
	} ELSE {
		If ($Command -Match " ") {$CMD = $Command.Split(" "); $C = $CMD[1]; $Command = $CMD[0]+" """+(Join-Path $Source $Naam\$C)+""""} ELSE {$Command = """"+(Join-Path $Source $Naam\$Command)+""""}
		Import-MDTApplication -Name $Naam -ShortName $Naam -enable "True" -CommandLine $Command -NoSource
	}
	If ($Reboot){Set-ItemProperty -path "DS001:\Applications\$Naam" -Name Reboot -Value True}
	While (Test-Path -Path $DeploymentShare\Control\Applications.LOCK){Start-Sleep -Milliseconds 10}
	Set-Location $location
}

#######
# Voeg nieuwe applicaties hieronder toe
# ImportApp("commandline") ("App naam/gelijk aan de mapnaam op $Source share") [("True voor reboot")]
#######
del "DS001:\Applications\*"
ForEach ($Folder in Get-Childitem -Path $Source) {
	If (!(Test-Path ($Folder.FullName + "\ExcludeMDT.txt"))) {
		If (Test-Path ($Folder.FullName + "\install.bat")) {
			If (Test-Path ($Folder.FullName + "\reboot.txt")) {
				ImportApp("install.bat") ($Folder.Name) ("True")
			} Else {
				ImportApp("install.bat") ($Folder.Name)
			}
		}
		If (Test-Path ($Folder.FullName + "\install.vbs")) {
			If (Test-Path ($Folder.FullName + "\reboot.txt")) {
				ImportApp("wscript install.vbs") ($Folder.Name) ("True")
			} Else {
				ImportApp("wscript install.vbs") ($Folder.Name)
			}
		}
	}
}

#######
# Voeg de nieuwe applicatie toe in de installatie volgorde voor XenApp
#######
# $Order = $Order + (Get-ItemProperty -Path "DS001:\Applications\AppName").Guid
#$Order = @()
#Set-ItemProperty -path "DS001:\Applications\VDA" -Name Dependency -Value $Order
