# Copy changed files.
$null = robocopy c:/chocoRoot c:/code/choco /e /copy:dt
# Purge any tests files that have been removed.
$null = robocopy c:/chocoRoot/tests c:/code/choco/tests /e /copy:dt /purge
Write-Host "($(Get-Date -Format "dddd MM/dd/yyyy HH:mm:ss K")) Starting Test Execution"
Push-Location c:/code/choco
# $env:TEST_KITCHEN = 1
$env:VM_RUNNING = 1
# The Invoke-Tests file will build the packages if the directory does not exist.
# This will allow to rerun tests without packaging each time.
& "$PWD/Invoke-Tests.ps1" -SkipPackaging -Tag Install-ChocolateyInstallPackage.Tests
Copy-Item $env:ALLUSERSPROFILE/chocolatey/logs/testInvocations.log C:/vagrant
Copy-Item "$PWD/tests/testResults.xml" C:/vagrant
