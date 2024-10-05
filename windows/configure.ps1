Write-Host "Enabling Dark Mode"
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0 -PropertyType DWORD -Force
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0 -PropertyType DWORD -Force

Write-Host "Hiding Search Box on the Taskbar"
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 0 -PropertyType DWORD -Force

Write-Host "Hiding the News and Interests icon from the Taskbar"
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds" -Name "ShellFeedsTaskbarViewMode" -Value 2 -PropertyType DWORD -Force

Write-Host "Using small Taskbar icons"
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSmallIcons" -Value 1

Write-Host "Hiding the Task View button"
Set-ItemProperty -Path "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Value "ShowTaskViewButton" -Value 0 -PropertyType DWORD -Force

Write-Host "Setting keyboard repeat delay to 10 milliseconds"
Set-ItemProperty -Path "HKEY_CURRENT_USER\Control Panel\Accessibility\Keyboard Response" -Value "DelayBeforeRepeat"-Value 10

Write-Host "Setting keyboard repeat rate to 100 repeats/second"
Set-ItemProperty -Path "HKEY_CURRENT_USER\Control Panel\Accessibility\Keyboard Response" -Name "RepeatRate" -Value 100

Write-Host "Showing Hidden Files and Folders"
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 1

Write-Host "Showing Checkmarks next to Files and Folders"
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "AutoCheckSelect" -Value 1

Write-Host "Showing File Extensions"
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0

Write-Host "Setting default web browser to Firefox"
Start-Process "firefox.exe" -ArgumentList "--setDefaultBrowser"

Write-Host "Restarting Windows Explorer to apply changes..."
Stop-Process -Name explorer -Force
Start-Process explorer
