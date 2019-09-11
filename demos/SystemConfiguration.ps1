#--- Enable developer mode on the system ---
Set-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\AppModelUnlock -Name AllowDevelopmentWithoutDevLicense -Value 1

# set desktop wallpaper
Invoke-WebRequest -Uri 'https://www.bike-magazin.de/fileadmin/pictures/wallpaper/2019/09-2018__16-9.jpg' -Method Get -ContentType image/jpeg -OutFile 'C:\wallpaper.jpg'
Set-ItemProperty -path 'HKCU:\Control Panel\Desktop\' -name wallpaper -value 'C:\wallpaper.jpg'
rundll32.exe user32.dll, UpdatePerUserSystemParameters
RefreshEnv
