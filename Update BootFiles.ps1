If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
Import-Module "C:\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
New-PSDrive -Name "DS001" -PSProvider MDTProvider -Root "D:\DeploymentShare"
update-MDTDeploymentShare -path "DS001:" -Force –Verbose

wdsutil /replace-image /image:"Lite Touch Windows PE (x86)" /imagetype:boot /Architecture:x86 /ReplacementImage /ImageFile:"D:\DeploymentShare\Boot\LiteTouchPE_x86.wim"
wdsutil /replace-image /image:"Lite Touch Windows PE (x64)" /imagetype:boot /Architecture:x64 /ReplacementImage /ImageFile:"D:\DeploymentShare\Boot\LiteTouchPE_x64.wim"

pause
