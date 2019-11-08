# Description: Boxstarter Script
# http://boxstarter.org/package/url?https://raw.githubusercontent.com/d4kr/windows-setup/master/install.ps1

Disable-UAC

#--- Configuring Windows properties ---
# Show hidden files, Show protected OS files, Show file extensions
#Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions
# Show file extensions
Set-WindowsExplorerOptions -DisableShowFileExtensions


#--- File Explorer Settings ---
# will expand explorer to the actual folder you're in
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneExpandToCurrentFolder -Value 1
#adds things back in your left pane like recycle bin
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneShowAllFolders -Value 1
#opens PC to This PC, not quick access
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Value 1
#taskbar where window is open for multi-monitor
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name MMTaskbarMode -Value 2


#--- Enable developer mode on the system ---
Set-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\AppModelUnlock -Name AllowDevelopmentWithoutDevLicense -Value 1


#--- Set desktop wallpaper ---
Invoke-WebRequest -Uri 'https://www.bike-magazin.de/fileadmin/pictures/wallpaper/2019/09-2018__16-9.jpg' -Method Get -ContentType image/jpeg -OutFile 'C:\wallpaper.jpg'
Set-ItemProperty -path 'HKCU:\Control Panel\Desktop\' -name wallpaper -value 'C:\wallpaper.jpg'
rundll32.exe user32.dll, UpdatePerUserSystemParameters
RefreshEnv


#--- Uninstall unnecessary applications that come with Windows out of the box ---
Write-Host "Uninstall some applications that come with Windows out of the box" -ForegroundColor "Yellow"

#Referenced to build script
# https://docs.microsoft.com/en-us/windows/application-management/remove-provisioned-apps-during-update
# https://github.com/jayharris/dotfiles-windows/blob/master/windows.ps1#L157
# https://gist.github.com/jessfraz/7c319b046daa101a4aaef937a20ff41f
# https://gist.github.com/alirobe/7f3b34ad89a159e6daa1
# https://github.com/W4RH4WK/Debloat-Windows-10/blob/master/scripts/remove-default-apps.ps1

function removeApp {
	Param ([string]$appName)
	Write-Output "Trying to remove $appName"
	Get-AppxPackage $appName -AllUsers | Remove-AppxPackage
	Get-AppXProvisionedPackage -Online | Where-Object DisplayName -like $appName | Remove-AppxProvisionedPackage -Online
}

$applicationList = @(
	"*MarchofEmpires*"
	"*Minecraft*"
	"*Solitaire*"
	"Microsoft.WindowsSoundRecorder"
	"Microsoft.XboxApp"
	"Microsoft.XboxIdentityProvider"
	"Microsoft.ZuneMusic"
	"Microsoft.ZuneVideo"
	"*BubbleWitch*"
    "king.com*"
    "G5*"
);

foreach ($app in $applicationList) {
    removeApp $app
}


#--- Developer Tools ---
# Install python
choco install -y python

# Refresh path
refreshenv

# Update pip
python -m pip install --upgrade pip

# Install ML related python packages through pip
pip install numpy

# Get Visual Studio C++ Redistributables
choco install -y vcredist20


#--- WSL Debian ---
choco install -y Microsoft-Windows-Subsystem-Linux --source="'windowsfeatures'"
# TODO: Move this to choco install once --root is included in that package
Invoke-WebRequest -Uri https://aka.ms/wsl-debian-gnulinux -OutFile ~/Debian.appx -UseBasicParsing
Add-AppxPackage -Path ~/Debian.appx
# run the distro once and have it install locally with root user, unset password

RefreshEnv
write-host "Installing Debian WSL..."
Debian install --root
write-host "Updating WSL distro..."
Debian run apt update
Debian run apt upgrade -y
write-host "Installing tools inside the WSL distro..."
Debian run apt install htop -y
RefreshEnv

remove-item ~/Debian.appx


#--- Import ZScaler Certificates ---
$certs = "https://raw.githubusercontent.com/d4kr/windows-setup/master/certs/ZscalerRootCertificate-2048-SHA256.crt", "https://raw.githubusercontent.com/d4kr/windows-setup/master/certs/ZscalerRootCertificate-2048.crt"
$certs | ForEach-Object {
	Invoke-WebRequest -Uri $_ -OutFile ~/zscaler.crt
	Import-Certificate -FilePath ~/zscaler.crt -CertStoreLocation cert:\CurrentUser\Root
	Remove-Item ~/zscaler.crt
}


#--- Personalize ---
choco install -y microsoft-teams
choco install -y office365business
choco install -y powershell-core
choco install -y googlechrome
choco install -y firefox
choco install -y opera
choco install -y vscode
choco install -y git --package-parameters="'/GitAndUnixToolsOnPath /WindowsTerminal'"
choco install -y 7zip.install
choco install -y vlc;
choco install -y git.install;
choco install -y putty.install;
choco install -y winscp.install;
choco install -y filezilla;
choco install -y openjdk;
choco install -y intellijidea-ultimate;
choco install -y telegram.install;
choco install -y --params '/NoDesktopIcon' teamviewer;
choco install -y nextcloud-client;
choco install -y adobereader;
choco install -y youtube-dl;
choco install -y sourcetree;
choco install -y mamp;
choco install -y virtualbox;

Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula

Exit-PSHostProcess

# *************************************************************
# OLD
# *************************************************************
# As root
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {   
    Write-Host "Not Admin"
    Exit
}

# Set Execution Policy for this Process only
Set-ExecutionPolicy Bypass -Scope Process -Force;

# WSL
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

# Da eseguire da PowerShell come amministratore
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {   
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Break
}

# Installazione di chocolatey
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));

# Configurazioni
choco feature enable -n allowGlobalConfirmation

# --params '/NoDesktopIcon' -y
