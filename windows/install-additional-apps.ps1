
function Install {

    param (
        $Url,
        $FileName,
        $PackageName,
        $Checksum,
        $InstallArgs
    )

    $package = Get-Package "$PackageName" -ErrorAction:SilentlyContinue
    if($?)
    {
        Write-Host "$PackageName already installed."
        return
    }

    $filePath = "$HOME\Downloads\$FileName"

    Write-Host "Downloading $FileName"
    $WebClient = New-Object System.Net.WebClient
    $WebClient.DownloadFile("$Url", $filePath)

    # Verify the checksum if one was provided
    if (-not ([string]::IsNullOrEmpty($Checksum)))
    {
        $hash = Get-FileHash "$filePath"
        if ($hash.Hash -ne $Checksum)
        {
            Write-Error "Checksum mismatch"
            return
        }
    }

    Write-Host "Running $filePath $InstallArgs"
    Start-Process -FilePath "$filePath" -ArgumentList $InstallArgs

    if ([string]::IsNullOrEmpty($InstallArgs))
    {
        Start-Process -FilePath "$filePath"
    }
    else
    {
        Start-Process -FilePath "$filePath" -ArgumentList $InstallArgs
    }
}

Install -PackageName "CORSAIR iCUE 4 Software" -Url "https://downloads.corsair.com/Files/CUE/iCUESetup_4.33.138_release.msi" -FileName "iCUESetup_4.33.138_release.msi" -Checksum "67331160822554F20342C693F27B7E998BDF9BFB74DF1B0F5ACB8510E05FE206" -InstallArgs "--silent"
Install -PackageName "Logitech G HUB" -Url "https://download01.logi.com/web/ftp/pub/techsupport/gaming/lghub_installer.exe" -FileName "lghub_installer.exe" -Checksum "6FAD9C90CA4D032B6582008F0D48EF2145EE600FF9BED066ADAB9DBDB8466322" -InstallArgs "/QN"
Install -PackageName "Battle.net" -Url "https://us.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe" -FileName "Battle.net-Setup.exe" -InstallArgs "--lang=enUS --installpath=`"C:\Program Files (x86)\Battle.net`"" # Different checksum each download
Install -PackageName "Battlestate Games Launcher 12.12.3.1964" -Url "https://cdn-13.eft-store.com/LauncherDistribs/12.12.3.1964_e2e3318cc21e98aa295934eb0ec15ffa/BsgLauncher.12.12.3.1964.exe" -Checksum "7E2B4D70564497C0BA340056E3535BEA88224051CE410F2C3336C49F0F7CBD99" -FileName "BsgLauncher.12.12.3.1964.exe"
