
# Download and install (windows) Node Version Manager (nvm)

param (
    [switch]$cleanup, # delete downloaded files after install
    [switch]$here, # download here rather that default download dir
    [switch]$verbose, # print progress
    [switch]$reinstall # reinstall even if already installed
)

if ($verbose) {
    $VerbosePreference = "Continue"
} else {
    $VerbosePreference = "SilentlyContinue"
}

# Get the directory the script was run from, or use the Downloads directory
if ($here) {
    $downloadDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
    Write-Verbose "Downloading to the current directory: $downloadDir"
} else {
    $downloadDir = [Environment]::GetFolderPath("MyDocuments") # Downloads directory
    Write-Verbose "Downloading to the Downloads directory: $downloadDir"
}

# Get the latest release from the nvm-windows GitHub repo
Write-Verbose "Fetching the latest release info..."
$latest = Invoke-RestMethod -Uri "https://api.github.com/repos/coreybutler/nvm-windows/releases/latest"
$latestVersion = $latest.tag_name.Trim('v')

# Get the currently installed NVM version
if (Get-Command nvm -ErrorAction SilentlyContinue) {
    $installedVersion = & nvm version
} else {
    $installedVersion = $null
}

if ($installedVersion -eq $latestVersion -and !$reinstall) {
    Write-Verbose "The latest version ($latestVersion) is already installed. No need to reinstall."
    exit
}

# Get the nvm-setup asset from the latest release
$installer = $latest.assets | Where-Object { $_.name -eq "nvm-setup.zip" }

# Set the zip path
$zipPath = "$downloadDir\nvm-setup.zip"

# Check if the file already exists
if (Test-Path $zipPath) {
    Write-Verbose "File already exists locally. Checking if it's the latest version..."

    # Get the SHA256 hash of the local file
    $localHash = (Get-FileHash -Path $zipPath -Algorithm SHA256).Hash

    # Download the remote file to a temporary location to get its hash
    Write-Verbose "Downloading the remote file to a temporary location..."
    $tempPath = "$downloadDir\temp.zip"
    Invoke-WebRequest -Uri $installer.browser_download_url -OutFile $tempPath
    $remoteHash = (Get-FileHash -Path $tempPath -Algorithm SHA256).Hash

    # If the hashes do not match, overwrite the local file with the remote file
    if ($localHash -ne $remoteHash) {
        Write-Verbose "The local file is outdated. Overwriting with the latest version..."
        Move-Item -Path $tempPath -Destination $zipPath -Force
    } else {
        # Delete the temporary file if the hashes match
        Write-Verbose "The local file is the latest version. No need to download again."
        Remove-Item -Path $tempPath
    }
} else {
    # Download the remote file if it does not already exist
    Write-Verbose "File doesn't exist locally. Downloading now..."
    Invoke-WebRequest -Uri $installer.browser_download_url -OutFile $zipPath
}

# Extract the zip file
Write-Verbose "Extracting the zip file..."
Expand-Archive -Path $zipPath -DestinationPath $downloadDir -Force

# Run the installer and wait for it to finish
Write-Verbose "Running the installer..."
$exePath = "$downloadDir\nvm-setup.exe"
Start-Process -FilePath $exePath -Wait

# Cleanup if requested
if ($cleanup) {
    Write-Verbose "Cleanup requested. Removing downloaded files..."
    Remove-Item -Path $zipPath
    Remove-Item -Path $exePath
}

Write-Verbose "Done."
