# User is created for access to the Deploymentshare
$MDTUsername = "MDTDeployment"
$MDTPassword = "MDTD3pl0ym3nt!"

# Clear the screen
clear

# Run as Admin
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit}

# Check for D Drive and create needed folders
If (!(Test-Path D:)) {Write-Host "D Drive not found! Please add a D-Drive to your system;pause;exit}
MD D:\MDT\Drivers

# Download and install ADK and WinPE
curl ((curl https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install -UseBasicParsing).Links | ? {$_.outerhtml -match "Windows ADK"})[0].href -UseBasicParsing -OutFile "D:\MDT\adksetup.exe"
curl ((curl https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install -UseBasicParsing).Links | ? {$_.outerhtml -match "Windows PE"})[0].href -UseBasicParsing -OutFile "D:\MDT\adkwinpesetup.exe"
start "D:\Software\ADK\adksetup.exe" "/features OptionId.DeploymentTools /norestart /ceip off /q" -Wait
start "D:\Software\ADK\adkwinpesetup.exe" "/features OptionId.WindowsPreinstallationEnvironment /norestart /ceip off /q" -Wait

# Download and install MDT
curl ((curl https://www.microsoft.com/en-us/download/confirmation.aspx?id=54259 -UseBasicParsing).Links | ? {$_.href -match "MicrosoftDeploymentToolkit_x64.msi"})[0].href -UseBasicParsing -OutFile "D:\MDT\MicrosoftDeploymentToolkit_x64.msi"
start "D:\MDT\MicrosoftDeploymentToolkit_x64.msi" "/qb /norestart" -Wait

# Add custom template files to MDT to set defaults for Task Sequences
ren "C:\Program Files\Microsoft Deployment Toolkit\Templates\Client.xml" "C:\Program Files\Microsoft Deployment Toolkit\Templates\ClientORG.xml"
Start-BitsTransfer https://raw.githubusercontent.com/hpmillaard/MDT/master/XMLs/Client.xml "C:\Program Files\Microsoft Deployment Toolkit\Templates\Client.xml"
ren "C:\Program Files\Microsoft Deployment Toolkit\Templates\Server.xml" "C:\Program Files\Microsoft Deployment Toolkit\Templates\ServerORG.xml"
Start-BitsTransfer https://raw.githubusercontent.com/hpmillaard/MDT/master/XMLs/Server.xml "C:\Program Files\Microsoft Deployment Toolkit\Templates\Server.xml"

# Create Deploymentshare
Import-Module "C:\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
MD D:\DeploymentShare
New-PSDrive -Name "DS001" -PSProvider "MDTProvider" -Root "D:\DeploymentShare" -Description "MDT Deployment Share" -NetworkPath "\\$ENV:COMPUTERNAME\DeploymentShare" | Add-MDTPersistentDrive
Start-BitsTransfer https://raw.githubusercontent.com/hpmillaard/MDT/master/MDTExitNameToGuid.vbs D:\DeploymentShare\Control\MDTExitNameToGuid.vbs

# Create MDT useraccount and add the information to Bootstrap.ini
$SecureMDTPassword = ConvertTo-SecureString -String $MDTPassword -AsPlainText -Force
New-LocalUser -AccountNeverExpires -Description "User for access to MDT Deploymentshare" -Name $MDTUsername -Password $SecureMDTPassword -PasswordNeverExpires -UserMayNotChangePassword | Add-LocalGroupMember -Group Users 
Add-Content D:\DeploymentShare\Control\Bootstrap.ini "SkipBDDWelcome=Yes`nUserid=$MDTUsername`nUserPassword=$MDTPassword`nUserdomain=$ENV:COMPUTERNAME`nDeployRoot=\\$ENV:COMPUTERNAME\DeploymentShare"

# Update the Deployment share
Update-MDTDeploymentShare -path "DS001:" -Force

# Install and configure WDS
Add-WindowsFeature WDS
If ((gwmi -Class Win32_computersystem).PartOfDomain) {WDSutil /Initialize-Server /RemInst:D:\RemoteInstall /Authorize} else {WDSutil /Initialize-Server /RemInst:D:\RemoteInstall /Standalone}
WDSutil /Add-Image /imagetype:boot /ImageFile:"D:\DeploymentShare\Boot\LiteTouchPE_x86.wim"
WDSutil /Add-Image /imagetype:boot /ImageFile:"D:\DeploymentShare\Boot\LiteTouchPE_x64.wim"
WDSutil /Set-Server /AnswerClients:All

# Download and import Apps
Start-BitsTransfer https://raw.githubusercontent.com/hpmillaard/MDT/master/Apps.zip D:\MDT\Apps.zip
Expand-Archive D:\MDT\Apps.zip -Destination D:\MDT\Apps -Force
del D:\MDT\Apps.zip
wscript "d:\MDT\Apps\Update all subfolders.vbs"
Start-BitsTransfer https://raw.githubusercontent.com/hpmillaard/MDT/master/MDT%20Apps.ps1 "D:\MDT\MDT Apps.ps1"
& "D:\MDT\MDT Apps.ps1"

