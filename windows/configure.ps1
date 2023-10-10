# Enable Dark Mode
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0 -PropertyType DWORD -Force

# Hide the Search Box on the Taskbar
$taskbarPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"
New-ItemProperty -Path $taskbarPath -Name "SearchboxTaskbarMode" -Value 1 -PropertyType DWORD -Force

# Hide the News and Interests Icon from the Taskbar
$taskbarPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds"
New-ItemProperty -Path $taskbarPath -Name "ShellFeedsTaskbarViewMode" -Value 2 -PropertyType DWORD -Force

# Set Default Web Browser to Firefox
Start-Process "firefox.exe" -ArgumentList "--setDefaultBrowser"

# Set Default PDF Reader to Firefox
$pdfReaderPath = "C:\Program Files\Mozilla Firefox\firefox.exe"  # Update the path as needed
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice" -Name "ProgId" -Value "FirefoxHTML" -Force
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\https\UserChoice" -Name "ProgId" -Value "FirefoxHTML" -Force
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\ftp\UserChoice" -Name "ProgId" -Value "FirefoxHTML" -Force
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\pdf\UserChoice" -Name "ProgId" -Value "FirefoxHTML" -Force

# Set the keyboard repeat delay to a shorter time (200 milliseconds)
Write-Host "Setting keyboard repeat delay to 200 milliseconds"
reg.exe add "HKEY_CURRENT_USER\Control Panel\Accessibility\Keyboard Response" /v DelayBeforeRepeat /t REG_SZ /d 200 /f

# Set the keyboard repeat rate to a faster rate (15 repeats/second)
Write-Host "Setting keyboard repeat rate to 15 repeats/second"
reg.exe add "HKEY_CURRENT_USER\Control Panel\Accessibility\Keyboard Response" /v RepeatRate /t REG_SZ /d 15 /f

# Restart Windows Explorer to apply the changes
Write-Host "Restarting Windows Explorer to apply changes..."
Stop-Process -Name explorer -Force
Start-Process explorer
