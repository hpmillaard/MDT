@echo off
wdsutil /set-server /pxepromptpolicy /new:optin /known:optin
cls
echo WDS set to press F12 to boot with PXE
echo.
echo If you don't want to change this, close the window now, otherwise
pause
wdsutil /set-server /pxepromptpolicy /new:optout /known:optout


exit
wdsutil /get-server /show:config
