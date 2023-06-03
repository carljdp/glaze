
# Allow all apps (and thus nvm) to make symlinks without prompting for permission
#   This script needs to be run as Administrator
#   ..and requires a restart

param (
    [switch]$Reset
)

$uacRegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$uacRegistryValueName = "EnableLUA"
$uacDefaultSetting = 1

# Check if the script is running with administrative privileges
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

if (-not $isAdmin) {
    Write-Host "This script needs to be run with administrative privileges. Please right-click on the script and select 'Run as administrator'."
    exit
}

# Check if the registry value exists
if (-not (Test-Path $uacRegistryPath)) {
    Write-Host "Unable to find the UAC registry path: $uacRegistryPath"
    exit
}

# Reset UAC (EnableLUA) to the default value
if ($Reset) {
    Set-ItemProperty -Path $uacRegistryPath -Name $uacRegistryValueName -Value $uacDefaultSetting
    Write-Host "UAC settings reverted to default."
}
# Disable UAC (EnableLUA) for the mklink command
else {
    Set-ItemProperty -Path $uacRegistryPath -Name $uacRegistryValueName -Value 0
    Write-Host "UAC settings modified successfully for the mklink command used by NVM."
}

Write-Host "Please restart your computer for the changes to take effect."
