# User will be created for access to the Deploymentshare
$MDTUsername = "MDTDeployment"
$MDTPassword = "MDTD3pl0ym3nt!"
$RootPath = "D:\MDT"
$Deploymentshare = "$RootPath\DeploymentShare"

Write-Host "Run as Admin" -ForegroundColor green
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit}

Write-Host "Check for RootPath and create needed folders" -ForegroundColor green
If (!(Test-Path $RootPath.Substring(0,2))) {clear;Write-Host "$RootPath.Substring(0,2) Drive not found! Please make sure that the drive exists and is formatted" -ForegroundColor red;pause;exit}
$Apps = "$RootPath\Apps"	;If (!(Test-Path "$Apps")) 	{MD "$Apps"}
$CS = "$RootPath\CustomSettings";If (!(Test-Path "$CS"))	{MD "$CS"}
$Drivers = "$RootPath\Drivers"	;If (!(Test-Path "$Drivers")) 	{MD "$Drivers"}
$ISO = "$RootPath\ISOs"		;If (!(Test-Path "$ISO")) 	{MD "$ISO"}
$Scripts = "$RootPath\Scripts"	;If (!(Test-Path "$Scripts")) 	{MD "$Scripts"}
$SW = "$RootPath\Software"	;If (!(Test-Path "$SW")) 	{MD "$SW"}
clear

Write-Host "Download Scripts" -ForegroundColor Green
Start-BitsTransfer "https://raw.githubusercontent.com/hpmillaard/MDT/master/Scripts.zip" "$Scripts\Scripts.zip"
Expand-Archive "$Scripts\Scripts.zip" -Destination $Scripts -Force
del "$Scripts\Scripts.zip"

Write-Host "Download ISOs" -ForegroundColor Green
Start-BitsTransfer "https://raw.githubusercontent.com/hpmillaard/MDT/master/ISOs.zip" "$ISO\ISOs.zip"
Expand-Archive "$ISO\ISOs.zip" -Destination $ISO -Force
del "$ISO\ISOs.zip"

Write-Host "Download CustomSettings" -ForegroundColor Green
Start-BitsTransfer "https://raw.githubusercontent.com/hpmillaard/MDT/master/CustomSettings.zip" "$CS\CustomSettings.zip"
Expand-Archive "$CS\CustomSettings.zip" -Destination $CS -Force
del "$CS\CustomSettings.zip"

Write-Host "Downloading ADK and WinPE" -ForegroundColor green
curl ((curl https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install -UseBasicParsing).Links | ? {$_.outerhtml -match "Windows ADK"})[0].href -UseBasicParsing -OutFile "$SW\adksetup.exe"
curl ((curl https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install -UseBasicParsing).Links | ? {$_.outerhtml -match "Windows PE"})[0].href -UseBasicParsing -OutFile "$SW\adkwinpesetup.exe"
Write-Host "Installing ADK and WinPE" -ForegroundColor green
start "$SW\adksetup.exe" -ArgumentList "/features OptionId.DeploymentTools /norestart /ceip off /q" -Wait
start "$SW\adkwinpesetup.exe" -ArgumentList "/features OptionId.WindowsPreinstallationEnvironment /norestart /ceip off /q" -Wait

Write-Host "Downloading MDT" -ForegroundColor green
curl ((curl https://www.microsoft.com/en-us/download/confirmation.aspx?id=54259 -UseBasicParsing).Links | ? {$_.href -match "MicrosoftDeploymentToolkit_x64.msi"})[0].href -UseBasicParsing -OutFile "$SW\MicrosoftDeploymentToolkit_x64.msi"
Write-Host "Installing MDT" -ForegroundColor green
start "$SW\MicrosoftDeploymentToolkit_x64.msi" -ArgumentList "/qb /norestart" -Wait

Write-Host "Add custom template files to MDT to set defaults for Task Sequences" -ForegroundColor green
ren "$ENV:ProgramFiles\Microsoft Deployment Toolkit\Templates\Client.xml" "$ENV:ProgramFiles\Microsoft Deployment Toolkit\Templates\ClientORG.xml"
Start-BitsTransfer https://raw.githubusercontent.com/hpmillaard/MDT/master/XMLs/Client.xml "$ENV:ProgramFiles\Microsoft Deployment Toolkit\Templates\Client.xml"
ren "$ENV:ProgramFiles\Microsoft Deployment Toolkit\Templates\Server.xml" "$ENV:ProgramFiles\Microsoft Deployment Toolkit\Templates\ServerORG.xml"
Start-BitsTransfer https://raw.githubusercontent.com/hpmillaard/MDT/master/XMLs/Server.xml "$ENV:ProgramFiles\Microsoft Deployment Toolkit\Templates\Server.xml"

Write-Host "Create Deploymentshare" -ForegroundColor green
Import-Module "$ENV:ProgramFiles\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
MD "$Deploymentshare"
New-PSDrive -Name "DS001" -PSProvider "MDTProvider" -Root "$Deploymentshare" -Description "MDT Deployment Share" -NetworkPath "\\$ENV:COMPUTERNAME\DeploymentShare" | Add-MDTPersistentDrive

Write-Host "Download and Import Operating Systems" -ForegroundColor green
Start PowerShell -ArgumentList $Scripts'\Download` and` import` OS.ps1'

Write-Host "Download and import Apps" -ForegroundColor green
Start-BitsTransfer "https://raw.githubusercontent.com/hpmillaard/MDT/master/Apps.zip" "$Apps\Apps.zip"
Expand-Archive "$Apps\Apps.zip" -Destination "$Apps" -Force
del $Apps\Apps.zip
Start wscript -ArgumentList `"$Apps\Update` all` subfolders.vbs`" -Wait
#New-SmbShare -Name Apps -Path $Apps -ReadAccess Everyone
Start powershell -ArgumentList $Scripts'\MDT` Apps.ps1'

Write-Host "Create MDT useraccount and configure the Deploymentshare" -ForegroundColor green
$SecureMDTPassword = ConvertTo-SecureString -String $MDTPassword -AsPlainText -Force
New-LocalUser -AccountNeverExpires -Description "User for access to MDT Deploymentshare" -Name $MDTUsername -Password $SecureMDTPassword -PasswordNeverExpires -UserMayNotChangePassword | Add-LocalGroupMember -Group Users 
Add-Content $Deploymentshare\Control\Bootstrap.ini "SkipBDDWelcome=Yes`nUserid=$MDTUsername`nUserPassword=$MDTPassword`nUserdomain=$ENV:COMPUTERNAME`nDeployRoot=\\$ENV:COMPUTERNAME\DeploymentShare"
Copy "$Scripts\MDTExitNameToGuid.vbs" "$Deploymentshare\Control\MDTExitNameToGuid.vbs"
Copy "$CS\Windows All.ini" "$Deploymentshare\Control\CustomSettings.ini"

Write-Host "Update the Deploymentshare" -ForegroundColor green
Update-MDTDeploymentShare -path "DS001:" -Force

Write-Host "Install and configure WDS" -ForegroundColor green
Add-WindowsFeature WDS
If ((gwmi -Class Win32_computersystem).PartOfDomain) {WDSutil /Initialize-Server /RemInst:D:\RemoteInstall /Authorize} else {WDSutil /Initialize-Server /RemInst:D:\RemoteInstall /Standalone}
WDSutil /Add-Image /imagetype:boot /ImageFile:"$Deploymentshare\Boot\LiteTouchPE_x86.wim"
WDSutil /Add-Image /imagetype:boot /ImageFile:"$Deploymentshare\Boot\LiteTouchPE_x64.wim"
WDSutil /Set-Server /AnswerClients:All

clear
Write-Host "MDT Installation has finished and ready for use" -ForegroundColor green
pause
