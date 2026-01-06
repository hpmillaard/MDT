$host.ui.RawUI.WindowTitle = "Install and Configure MDT"

# User will be created for access to the Deploymentshare
$MDTUsername = "MDTDeployment"
$MDTPassword = "MDTD3pl0ym3nt!"
$RootPath = "D:\MDT"
$Deploymentshare = "$RootPath\DeploymentShare"

Write-Host "Run as Admin" -f green
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {Start powershell "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit}

Write-Host "Check for RootPath and create needed folders" -f green
If (!(Test-Path $RootPath.Substring(0,2))) {clear;Write-Host "$RootPath.Substring(0,2) Drive not found! Please make sure that the drive exists and is formatted" -f red;pause;exit}
$Directories = @{ Apps = "Apps"; CS = "CustomSettings"; Drivers = "Drivers"; Extra = "Extra"; ISO = "ISOs"; Scripts = "Scripts"; SW = "Software" }
foreach ($Key in $Directories.Keys) {
    $FullPath = Join-Path -Path $RootPath -ChildPath $Directories[$Key]
    If (!(Test-Path $FullPath)) {$null = MD $FullPath}
    Set-Variable -Name $Key -Value $FullPath -Scope Global
}

Write-Host "Disable IE Enhanced Security Configuration" -f green
$null = REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}" /v "IsInstalled" /d 0 /t REG_DWORD /f
$null = REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}" /v "IsInstalled" /d 0 /t REG_DWORD /f 

function Get-FileWithCheck($url, $path, $minSize) { try { iwr $url -OutFile $path } catch { Write-Host "Download failed: $(Split-Path $path -Leaf)" -f red; pause; exit }; if (!(Test-Path $path) -or (Get-Item $path).Length -lt $minSize) { Write-Host "File invalid: $(Split-Path $path -Leaf)" -f red; pause; exit } }

Write-Host "Downloading ADK" -f green
Get-FileWithCheck ((iwr https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install -UseBasicParsing).Links | ? {$_.outerhtml -match "Windows ADK"})[0].href "$SW\adksetup.exe" 1MB
Get-FileWithCheck ((iwr https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install -UseBasicParsing).Links | ? {$_.outerhtml -match "Windows PE" -or $_.outerhtml -match "WinPE"})[0].href "$SW\adkwinpesetup.exe" 1MB

Write-Host "Downloading MDT" -f green
Get-FileWithCheck "https://raw.githubusercontent.com/hpmillaard/MDT/master/MicrosoftDeploymentToolkit_x64.msi" "$SW\MicrosoftDeploymentToolkit_x64.msi" 10MB

Write-Host "Installing ADK" -f green
start "$SW\adksetup.exe" "/features OptionId.DeploymentTools /norestart /ceip off /q" -Wait

Write-Host "Installing ADK WinPE Addon" -f green
start "$SW\adkwinpesetup.exe" "/features OptionId.WindowsPreinstallationEnvironment /norestart /ceip off /q" -Wait
$WinPEWim = "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\en-us\winpe.wim"
if (!(Test-Path $WinPEWim)) {
    Write-Host "WinPE not found, retrying installation..." -f yellow
    start "$SW\adkwinpesetup.exe" "/features OptionId.WindowsPreinstallationEnvironment /norestart /ceip off /q" -Wait
    if (!(Test-Path $WinPEWim)) {
        Write-Host "ERROR: WinPE installation failed after retry!" -f red
        Write-Host "Script cannot continue without WinPE. Please install manually." -f red
        pause
        exit
    }
}

Write-Host "Installing MDT" -f green
start "$SW\MicrosoftDeploymentToolkit_x64.msi" "/qb /norestart" -Wait

Write-Host "Add custom template files to MDT to set defaults for Task Sequences" -f green
ren "$ENV:ProgramFiles\Microsoft Deployment Toolkit\Templates\Client.xml" "$ENV:ProgramFiles\Microsoft Deployment Toolkit\Templates\ClientORG.xml"
Start-BitsTransfer https://raw.githubusercontent.com/hpmillaard/MDT/master/XMLs/Client.xml "$ENV:ProgramFiles\Microsoft Deployment Toolkit\Templates\Client.xml"
ren "$ENV:ProgramFiles\Microsoft Deployment Toolkit\Templates\Server.xml" "$ENV:ProgramFiles\Microsoft Deployment Toolkit\Templates\ServerORG.xml"
Start-BitsTransfer https://raw.githubusercontent.com/hpmillaard/MDT/master/XMLs/Server.xml "$ENV:ProgramFiles\Microsoft Deployment Toolkit\Templates\Server.xml"

Write-Host "Create Deploymentshare" -f green
Import-Module "$ENV:ProgramFiles\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
$null = MD "$Deploymentshare"
$null = New-PSDrive -Name "DS001" -PSProvider "MDTProvider" -Root "$Deploymentshare" -Description "MDT Deployment Share" | Add-MDTPersistentDrive
$null = New-SmbShare -Name DeploymentShare -Path "$Deploymentshare" -FullAccess Everyone -Description "MDT Deployment Share"

Write-Host "Disable x86" -f green
sp DS001:\ -Name SupportX86 -Value $false

Write-Host "Configure Monitoring" -f green
sp DS001:\ -Name MonitorHost -Value $ENV:COMPUTERNAME
Enable-MDTMonitorService -EventPort 9800 -DataPort 9801

Write-Host "Download CustomSettings" -f Green
Start-BitsTransfer "https://raw.githubusercontent.com/hpmillaard/MDT/master/CustomSettings.zip" "$CS\CustomSettings.zip"
Expand-Archive "$CS\CustomSettings.zip" -Destination $CS -Force
del "$CS\CustomSettings.zip"

Write-Host "Download Scripts" -f Green
Start-BitsTransfer "https://raw.githubusercontent.com/hpmillaard/MDT/master/Scripts.zip" "$Scripts\Scripts.zip"
Expand-Archive "$Scripts\Scripts.zip" -Destination $Scripts -Force
del "$Scripts\Scripts.zip"

Write-Host "Download Extra" -f Green
Start-BitsTransfer "https://raw.githubusercontent.com/hpmillaard/MDT/master/Extra.zip" "$CS\Extra.zip"
Expand-Archive "$CS\Extra.zip" -Destination $Extra -Force
del "$CS\Extra.zip"
sp DS001:\ -Name 'Boot.x64.ExtraDirectory' -Value "$Extra\x64"
copy "$Extra\x64\*" "$Deploymentshare\Tools\x64\"

Write-Host "Create MDT useraccount and configure the Deploymentshare" -F green
$SecureMDTPassword = ConvertTo-SecureString $MDTPassword -A -F
New-LocalUser -AccountNeverExpires -Description "User for access to MDT Deploymentshare" -Name $MDTUsername -Password $SecureMDTPassword -PasswordNeverExpires -UserMayNotChangePassword | Add-LocalGroupMember -Group Users 
ac $Deploymentshare\Control\Bootstrap.ini "SkipBDDWelcome=Yes`nUserid=$MDTUsername`nUserPassword=$MDTPassword`nUserdomain=$ENV:COMPUTERNAME`nDeployRoot=\\$ENV:COMPUTERNAME\DeploymentShare"
Copy "$Scripts\MDTExitNameToGuid.vbs" "$Deploymentshare\Control\MDTExitNameToGuid.vbs"
Copy "$CS\Windows All.ini" "$Deploymentshare\Control\CustomSettings.ini"

Write-Host "Update the Deploymentshare" -f green
Update-MDTDeploymentShare -path "DS001:" -Force

Write-Host "Install and configure WDS" -f green
$null = Add-WindowsFeature WDS
If ((gwmi -Class Win32_computersystem).PartOfDomain) {$null = WDSutil /Initialize-Server /RemInst:$RootPath\RemoteInstall /Authorize} else {$null = WDSutil /Initialize-Server /RemInst:$RootPath\RemoteInstall /Standalone}
$null = WDSutil /Add-Image /imagetype:boot /ImageFile:"$Deploymentshare\Boot\LiteTouchPE_x64.wim"
$null = WDSutil /Set-Server /AnswerClients:All
If ((Get-WindowsFeature DHCP).InstallState -eq "Installed"){$null = WDSutil /Set-Server /DhcpOption60:Yes}
$null = Start-Service WDSServer

Write-Host "Download ISOs" -f Green
Start-BitsTransfer "https://raw.githubusercontent.com/hpmillaard/MDT/master/ISOs.zip" "$ISO\ISOs.zip"
Expand-Archive "$ISO\ISOs.zip" -Destination $ISO -Force
del "$ISO\ISOs.zip"

Write-Host "Download and Import Operating Systems" -f green
Start PowerShell $Scripts'\Download` and` import` OS.ps1'

Write-Host "Download and import Apps" -f green
Start-BitsTransfer "https://raw.githubusercontent.com/hpmillaard/MDT/master/Apps.zip" "$Apps\Apps.zip"
Expand-Archive "$Apps\Apps.zip" -Destination "$Apps" -Force
del $Apps\Apps.zip
Start wscript `"$Apps\Update` all` subfolders.vbs`" -Wait
New-SmbShare -Name Apps -Path $Apps -ReadAccess Everyone
Start powershell $Scripts'\MDT` Apps.ps1'

clear
Write-Host "MDT Installation has finished and ready for use" -f green
pause
restart-computer