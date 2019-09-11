# Description: Boxstarter Script
# Author: Microsoft
# http://boxstarter.org/package/url?https://raw.githubusercontent.com/d4kr/windows-setup/master/install.ps1

Disable-UAC
$ConfirmPreference = "None" #ensure installing powershell modules don't prompt on needed dependencies

# Get the base URI path from the ScriptToCall value
$bstrappackage = "-bootstrapPackage"
$helperUri = $Boxstarter['ScriptToCall']
$strpos = $helperUri.IndexOf($bstrappackage)
$helperUri = $helperUri.Substring($strpos + $bstrappackage.Length)
$helperUri = $helperUri.TrimStart("'", " ")
$helperUri = $helperUri.TrimEnd("'", " ")
$helperUri = $helperUri.Substring(0, $helperUri.LastIndexOf("/"))
$helperUri += "/scripts"
write-host "helper script base URI is $helperUri"

function executeScript {
    Param ([string]$script)
    write-host "executing $helperUri/$script ..."
    invoke-expression ((new-object net.webclient).DownloadString("$helperUri/$script"))
}

#--- Setting up Windows ---
executeScript "FileExplorerSettings.ps1";
executeScript "SystemConfiguration.ps1";
executeScript "RemoveDefaultApps.ps1";
executeScript "CommonDevTools.ps1";
executeScript "PythonMLTools.ps1"
executeScript "Browsers.ps1";
executeScript "WSL-debian.ps1";
RefreshEnv

choco install -y powershell-core

# personalize
choco install -y microsoft-teams
choco install -y office365business

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

# Import ZScaler Certificates
Get-ChildItem certs/* | ForEach-Object {
    $file = ( Get-ChildItem -Path $_.FullName )
    $file | Import-Certificate -CertStoreLocation cert:\CurrentUser\Root
}

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

# Packages
choco install tor-browser;
choco install 7zip.install;
choco install vlc;
choco install git.install;
choco install putty.install;
choco install winscp.install;
choco install vscode;
choco install dropbox
choco install filezilla;
choco install openjdk;
choco install androidstudio;
choco install intellijidea-ultimate;
choco install icloud;
choco install telegram.install;
choco install steam;
choco install teamviewer;
choco install unity unity-ios unity-android unity-mac;
choco install itunes;
choco install nextcloud-client;

choco install adobereader;

choco install python;
choco install pycharm;
choco install youtube-dl;
choco install sourcetree;
choco install mamp;
choco install phpstorm;

choco install royalts;

choco install 1password;

choco install virtualbox;

# --params '/NoDesktopIcon' -y