clear
$curpath = Split-Path -Parent $PSCommandPath

# Download and install ADK and WinPE
curl ((curl https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install -UseBasicParsing).Links | ? {$_.outerhtml -match "Windows ADK"})[0].href -UseBasicParsing -OutFile "$curpath\adksetup.exe"
curl ((curl https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install -UseBasicParsing).Links | ? {$_.outerhtml -match "Windows PE"})[0].href -UseBasicParsing -OutFile "$curpath\adkwinpesetup.exe"
.\adksetup.exe /features OptionId.DeploymentTools /norestart /ceip off /q
.\adkwinpesetup.exe /features OptionId.WindowsPreinstallationEnvironment /norestart /ceip off /q

# Download and install MDT
curl ((curl https://www.microsoft.com/en-us/download/confirmation.aspx?id=54259 -UseBasicParsing).Links | ? {$_.href -match "manually"}).href -UseBasicParsing -OutFile "$curpath\MicrosoftDeploymentToolkit_x64.msi"
.\MicrosoftDeploymentToolkit_x64.msi /qb /norestart

# Create Deploymentshare
Import-Module "C:\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
MD D:\DeploymentShare
New-PSDrive -Name "DS001" -PSProvider "MDTProvider" -Root "D:\DeploymentShare" -Description "MDT Deployment Share" -NetworkPath "\\$ENV:COMPUTERNAME\DeploymentShare$" -Verbose | add-MDTPersistentDrive –Verbose

# Install 
Add-WindowsFeature WDS
WDSutil /Initialize-Server /RemInst:D:\RemoteInstall /Authorize
WDSutil /Set-Server /AnswerClients:All

