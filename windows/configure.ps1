
Set-ExecutionPolicy Unrestricted -Scope Process

# https://github.com/Raphire/Win11Debloat
& ([scriptblock]::Create((irm "https://win11debloat.raphi.re/"))) -RunDefaults -Silent -RemoveApps -RemoveCommApps -RemoveW11Outlook -RemoveGamingApps -DisableDVR -ClearStart -DisableTelemetry -DisableBing -DisableSuggestions -DisableDesktopSpotlight -DisableLockscreenTips -ShowHiddenFolders -ShowKnownFileExt -HideDupliDrive -TaskbarAlignLeft -HideSearchTb -HideTaskview -HideChat -DisableWidgets -DisableCopilot -DisableRecall -HideHome -HideGallery -ExplorerToThisPC

Write-Host "Setting keyboard repeat delay to 10 milliseconds"
Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "KeyboardDelay" -Value 0

Write-Host "Setting keyboard repeat rate to 100 repeats/second"
Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "KeyboardSpeed" -Value 50

Write-Host "Setting default web browser to Firefox"
Start-Process "firefox.exe" -ArgumentList "--setDefaultBrowser"

Write-Host "Applying ShutUp 10 Config"
Start-Process shutup10 .\windows\ooshutup10.cfg /quiet

Write-Host "Enabling Hyper-V"
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All

Write-Host "Windows Subsystem for Linux"
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All

Write-Host "Virtual Mahcine Platform"
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -All

Write-Host "Restarting Windows Explorer to apply changes..."
Stop-Process -Name explorer -Force
Start-Process explorer
