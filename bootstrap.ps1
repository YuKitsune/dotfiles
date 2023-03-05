
# Ensure Chocolatey is installed
if(!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "🍫 Downloading and Installing chocolatey"
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
} else {
    Write-Host "🍫 chocolatey installed"
}

# Ensure Scoop is installed
if(!(Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "📦 Downloading and Installing scoop"
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser # Optional: Needed to run a remote script the first time
    irm get.scoop.sh | iex
} else {
    Write-Host "📦 scoop installed"
}

# Ensure gum is installed
if(!(Get-Command gum -ErrorAction SilentlyContinue)) {
    Write-Host "🍬 Downloading and Installing Gum"
    scoop install charm-gum
} else {
    Write-Host "🍬 gum installed"
}

# Ensure task is installed
if(!(Get-Command task -ErrorAction SilentlyContinue)) {
    Write-Host "🏃 Downloading and Installing task"
    choco install go-task
} else {
    Write-Host "🏃 task installed"
}

# Ensure winget is installed
if(!(Get-Command task -ErrorAction SilentlyContinue)) {
    Write-Host "📦 winget not installed. Please install it from the Microsoft Store: https://www.microsoft.com/p/app-installer/9nblggh4nns1"
    exit 1
} else {
    Write-Host "📦 winget installed"
}
