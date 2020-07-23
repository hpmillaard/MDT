# MDT
To automate the setup of MDT I've created all these scripts and configuration Files to setup Microsoft Deployment Toolkit as fast as possible.

# Server Setup
Setup a Windows Server OS as you normally do. Add a hard disk D: and format it with NTFS. I recommend about 100GB, but this also depends on the needed capabilities.

Run the [Download and install.ps1](Download and install.ps1) script. This script will download ADK, WinPE, MDT and will install WDS on the D: disk. This will also download the needed scripts that can be found in the [Scripts.zip](Scripts.zip) and [ISOs.zip](ISOs.zip)

# Scripts
The [Scripts.zip](Scripts.zip) is downloaded and extracted to the D:\MDT\Scripts folder and contains several scripts:
- Download and import OS.ps1 = This script will download and import the Operating Systems that you want to deploy with MDT.
- Import Drivers.ps1 = This script can be used to import drivers for specific hardware. Please edit this script before using it, an example is included in the script.
- MDT Apps.ps1 = This script is used to import applications into you Deployment share.
- Media.ps1 = This script can be used to create an ISO that you can use in combination with [Rufus](https://rufus.ie) to create USB media. With this you can install the chosen Windows version and Apps from your USB drive.

# Apps
The [Apps.zip](Apps.zip) is downloaded and extracted to D:\MDT\Apps. This folder contains a subfolder for each application.
All applications will be installed with the install.vbs or install.bat file.
To download the latest versions, you can easily run the D:\MDT\Apps\Update all subfolders.vbs file.
To update a specific app, you can run the Update.ps1 file in each application folder.

Adding your own apps requires you to create a folder in D:\MDT\Apps with an install.vbs or install.bat file. Please use the other scripts included as examples.

After you have downloaded all the latest versions of the apps and added your own apps, make sure you run the D:\MDT\Scripts\MDT App.ps1 script to update the MDT Deploymentshare

  # Custom Apps
   # Activate MU
This application/script will activate Microsoft Update. (Needed if you want to update Office and other Microsoft software during Windows Update)

   # Finish Installation
These scripts customize Windows components and will install of remove the following components:
- .Net Framework 3.5 and TelnetClient will be installed (see Windows Components.vbs)
- Faxing and Printing features are removed (see Windows Components.vbs)
- All Appx packages, except Calculator, Photos, ScreenSketch, Stickynotes and Microsoft Store (see Windows Components.vbs)
- All Store Apps will be updated (see Windows Components.vbs)
- All Powershell help files will be updated (see Windows Components.vbs)
- Recovery Agent is disabled (see Windows Components.vbs)
- WinRM is configured (see Windows Components.vbs)
- Winsat is run (see Windows Components.vbs)
- Firewall is set to Private Profile (see install.vbs)
- Firewall rules are configured (see install.vbs)
- Default file extentions are configured (which can easily be updated with your own preferences by running the "export DefaultApps.bat" script on a configured system)
- Default start menu layout for all users (which can easily be updated with your own preferences by running the "export Start Menu.bat" script on a configured system)
- If you place a "Background.jpg" in this folder, the desktop background will be set for all new user profiles
- If you place a "UserLogo.bmp" in this folder, the user picture will be changed for the all users
- Hibernation and Sleep will be turned off (see install.vbs)
- No password is required after screensaver (see install.vbs)
- Screenbrightness is set to 100% (see install.vbs)
- If you use WSUS during deployment, this will be removed at the next startup (see install.vbs)

    # Fonts
All Fonts that you want to deploy can be places in the folder Fonts and will be installed during deployment.

   # WLAN profiles
If you need to import specific WLAN SSID's during deployment of an MDT client, you can run the D:\MDT\Apps\ConnectWLAN\export.bat script to export the needed settings for an SSID. This will create a "SSID.xml" file in the folder and will be imported when a Task Sequence is run.

   # Regfiles
Numerous registry settings will be set. Look in the Regfiles folder for all settings. If you add your own .reg file to this folder, this will be included during deployment.
