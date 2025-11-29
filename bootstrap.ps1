
RefreshEnv

# Ensure gum is installed
if(!(Get-Command gum -ErrorAction SilentlyContinue)) {
    Write-Host "`Downloading and Installing gum"
    scoop install charm-gum
    RefreshEnv
} else {
    Write-Host "`gum installed"
}

# Ensure task is installed
if(!(Get-Command task -ErrorAction SilentlyContinue)) {
    Write-Host "`Downloading and Installing task"
    scoop install task
    RefreshEnv
} else {
    Write-Host "`task installed"
}

# Ensure winget is installed
if(!(Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "`winget not installed. Please install it from the Microsoft Store: https://www.microsoft.com/p/app-installer/9nblggh4nns1"
    exit 1
} else {
    Write-Host "`winget installed"
}
