If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit}

clear
If (!(Test-Path D:)) {Write-Host "D Drive not found! Please add a D-Drive to your system;pause;exit}
MD D:\Software\ADK
MD D:\Software\MDT

# Download and install ADK and WinPE
curl ((curl https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install -UseBasicParsing).Links | ? {$_.outerhtml -match "Windows ADK"})[0].href -UseBasicParsing -OutFile "D:\Software\ADK\adksetup.exe"
curl ((curl https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install -UseBasicParsing).Links | ? {$_.outerhtml -match "Windows PE"})[0].href -UseBasicParsing -OutFile "D:\Software\ADK\adkwinpesetup.exe"
start -FilePath "D:\Software\ADK\adksetup.exe" -ArgumentList "/features OptionId.DeploymentTools /norestart /ceip off /q" -Wait
start -FilePath "D:\Software\ADK\adkwinpesetup.exe" -ArgumentList "/features OptionId.WindowsPreinstallationEnvironment /norestart /ceip off /q" -Wait

# Download and install MDT
curl ((curl https://www.microsoft.com/en-us/download/confirmation.aspx?id=54259 -UseBasicParsing).Links | ? {$_.href -match "MicrosoftDeploymentToolkit_x64.msi"})[0].href -UseBasicParsing -OutFile "D:\Software\MDT\MicrosoftDeploymentToolkit_x64.msi"
start -FilePath "D:\Software\MDT\MicrosoftDeploymentToolkit_x64.msi" -ArgumentList "/qb /norestart" -Wait

# Create Deploymentshare
Import-Module "C:\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
MD D:\DeploymentShare
New-PSDrive -Name "DS001" -PSProvider "MDTProvider" -Root "D:\DeploymentShare" -Description "MDT Deployment Share" -NetworkPath "\\$ENV:COMPUTERNAME\DeploymentShare$" | Add-MDTPersistentDrive
Update-MDTDeploymentShare -path "DS001:" -Force

# Install and configure WDS
Add-WindowsFeature WDS
If ((gwmi -Class Win32_computersystem).PartOfDomain) {WDSutil /Initialize-Server /RemInst:D:\RemoteInstall /Authorize} else {WDSutil /Initialize-Server /RemInst:D:\RemoteInstall /Standalone}
WDSutil /Add-Image /imagetype:boot /ImageFile:"D:\DeploymentShare\Boot\LiteTouchPE_x86.wim"
WDSutil /Add-Image /imagetype:boot /ImageFile:"D:\DeploymentShare\Boot\LiteTouchPE_x64.wim"
WDSutil /Set-Server /AnswerClients:All
