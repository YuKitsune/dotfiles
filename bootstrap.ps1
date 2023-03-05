
RefreshEnv

# Ensure Chocolatey is installed
if(!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "`u{1F36B} Downloading and Installing chocolatey"
    
    # Source https://docs.chocolatey.org/en-us/choco/setup#non-administrative-install

    # Set directory for installation - Chocolatey does not lock
    # down the directory if not the default
    $InstallDir='C:\ProgramData\chocoportable'
    $env:ChocolateyInstall="$InstallDir"

    # If your PowerShell Execution policy is restrictive, you may
    # not be able to get around that. Try setting your session to
    # Bypass.
    Set-ExecutionPolicy Bypass -Scope Process -Force;

    # All install options - offline, proxy, etc at
    # https://chocolatey.org/install
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    RefreshEnv
} else {
    Write-Host "`u{1F36B} chocolatey installed"
}

# Ensure Scoop is installed
if(!(Get-Command scoop -ErrorAction SilentlyContinue)) {

    # Source: https://github.com/ScoopInstaller/Install#readme

    Write-Host "`u{1FAA3} Downloading and Installing scoop"
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser # Optional: Needed to run a remote script the first time
    Invoke-RestMethod get.scoop.sh | Invoke-Expression
    RefreshEnv
} else {
    Write-Host "`u{1FAA3} scoop installed"
}

# Ensure gum is installed
if(!(Get-Command gum -ErrorAction SilentlyContinue)) {
    Write-Host "`u{1F36C} Downloading and Installing gum"
    scoop install charm-gum
    RefreshEnv
} else {
    Write-Host "`u{1F36C} gum installed"
}

# Ensure task is installed
if(!(Get-Command task -ErrorAction SilentlyContinue)) {
    Write-Host "`u{1F3C3} Downloading and Installing task"
    scoop install task
    RefreshEnv
} else {
    Write-Host "`u{1F3C3} task installed"
}

# Ensure winget is installed
if(!(Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "`u{1F4E6} winget not installed. Please install it from the Microsoft Store: https://www.microsoft.com/p/app-installer/9nblggh4nns1"
    exit 1
} else {
    Write-Host "`u{1F4E6} winget installed"
}
