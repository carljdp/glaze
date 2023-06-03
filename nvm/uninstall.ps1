
# Uninstall (windows) Node Version Manager (nvm)

# Check if nvm is installed
if (Get-Command 'nvm' -ErrorAction SilentlyContinue) {
    Write-Host "nvm is installed. Proceeding with uninstallation."

    # Unset nvm related environment variables
    [Environment]::SetEnvironmentVariable("NVM_HOME", $null, "User")
    [Environment]::SetEnvironmentVariable("NVM_SYMLINK", $null, "User")

    # Reload the environment variables
    $env:NVM_HOME = $null
    $env:NVM_SYMLINK = $null

    # TODO - do we really also need to remove the npm dirs?
    # Remove nvm directories and Node.js versions if they exist
    $dirs = @("~\AppData\Roaming\nvm", "~\AppData\Roaming\npm", "~\AppData\Roaming\npm-cache")
    foreach ($dir in $dirs) {
        $fullPath = Resolve-Path $dir -ErrorAction SilentlyContinue
        if ($fullPath) {
            Remove-Item -Recurse -Force $fullPath
            Write-Host "Removed directory $fullPath"
        }
    }

    Write-Host "nvm and Node.js versions have been uninstalled."
} else {
    Write-Host "nvm is not installed."
}
