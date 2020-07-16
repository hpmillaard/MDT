wdsutil /replace-image /server:SERVER01 /image:"Lite Touch Windows PE (x86)" /imagetype:boot /Architecture:x86 /ReplacementImage /ImageFile:"D:\DeploymentShare\Boot\LiteTouchPE_x86.wim"
wdsutil /replace-image /server:SERVER01 /image:"Lite Touch Windows PE (x64)" /imagetype:boot /Architecture:x64 /ReplacementImage /ImageFile:"D:\DeploymentShare\Boot\LiteTouchPE_x64.wim"
pause
wdsutil /replace-image /server:SERVER02 /image:"Lite Touch Windows PE (x86)" /imagetype:boot /Architecture:x86 /ReplacementImage /ImageFile:"D:\DeploymentShare\Boot\LiteTouchPE_x86.wim"
wdsutil /replace-image /server:SERVER02 /image:"Lite Touch Windows PE (x64)" /imagetype:boot /Architecture:x64 /ReplacementImage /ImageFile:"D:\DeploymentShare\Boot\LiteTouchPE_x64.wim"
pause