# Enable strict error handling
$ErrorActionPreference = "Stop"

# Function to handle Ctrl+C interruption
function Set-InterruptHandler {
    $Handler = Register-EngineEvent -SourceIdentifier ConsoleControlCHandler -Action {
        Write-Host "SIGINT detected. Exiting..."
        exit 1
    }
}

Write-Host "🔑 Configuring SSH keys"

Write-Host "✋ Before we try to import SSH keys, ensure the external volume is connected, then press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

Write-Host "📁 Please select a directory containing SSH keys"
$source_dir = (Get-Item -LiteralPath (Read-Host "Enter the path to the directory containing SSH keys")).FullName

Write-Host "📁 Sourcing SSH keys from $source_dir"

# Check if the source directory exists
if (-Not (Test-Path $source_dir -PathType Container)) {
    Write-Host "🤷 Source directory not found"
    exit 1
}

# List all files in the directory
$files = Get-ChildItem -Path $source_dir -File

# Define the target directory for SSH keys
$ssh_dir = "$env:USERPROFILE\.ssh"

# Create the directory if it does not exist
if (-Not (Test-Path $ssh_dir)) {
    New-Item -Path $ssh_dir -ItemType Directory
}

# Loop over each file in the source directory
foreach ($file in $files) {
    $source_file = $file.FullName
    $target = "$ssh_dir\$($file.Name)"

    # Check if the file already exists in the target directory
    if (Test-Path $target) {
        $overwrite = Read-Host "👯‍♀️ $($file.Name) already exists in $target. Overwrite? (y/n)"
        if ($overwrite -eq 'n') {
            Write-Host "🔁 Skipping $($file.Name)"
            continue
        }
        else {
            Remove-Item -Path $target
        }
    }

    Write-Host "📥 Copying '$source_file' to '$target'"
    Copy-Item -Path $source_file -Destination $target

    # Set the file permissions to 600
    # We use `icacls` here as PowerShell does not have an easy equivalent to `chmod` for ACLs
    icacls $target /inheritance:r
    icacls $target /grant:r "$($env:USERNAME):(F)"
}
