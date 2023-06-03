
# Print env vars that contain 'node' or 'nvm'

Get-ChildItem Env: | Where-Object {$_.Name -match 'node|nvm' -or $_.Value -match 'node|nvm'} | ForEach-Object {
    $name = $_.Name
    $value = $_.Value -split ';'
    $filteredValues = $value | Where-Object {$_ -match 'node|nvm'}

    if ($filteredValues) {
        Write-Host "${name}: "
        $filteredValues | ForEach-Object {
            Write-Host $_
        }
    }
}
