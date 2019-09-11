choco install -y Microsoft-Windows-Subsystem-Linux --source="'windowsfeatures'"

#--- Debian ---
# TODO: Move this to choco install once --root is included in that package
Invoke-WebRequest -Uri https://aka.ms/wsl-debian-gnulinux -OutFile ~/Debian.appx -UseBasicParsing
Add-AppxPackage -Path ~/Debian.appx
# run the distro once and have it install locally with root user, unset password

RefreshEnv
write-host "Installing Debain WSL..."
Debian install --root
write-host "Updating WSL distro..."
Debian run apt update
Debian run apt upgrade -y
write-host "Installing tools inside the WSL distro..."
Debian run apt install htop -y
