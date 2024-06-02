Write-Host "($(Get-Date -Format "dddd MM/dd/yyyy HH:mm:ss K")) Clearing the packages directory"
Remove-Item "$env:TEMP/chocolateyTests/packages" -Recurse -Force -ErrorAction SilentlyContinue
