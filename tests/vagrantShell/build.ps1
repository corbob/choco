$null = robocopy c:/chocoRoot c:/code/choco /e /copy:dt /purge
Push-Location c:/code/choco
Write-Host "($(Get-Date -Format "dddd MM/dd/yyyy HH:mm:ss K")) Files have been copied, beginning build process."
$CakeOutput = ./build.bat --verbosity=diagnostic --target=CI --testExecutionType=none --shouldRunalyze=false --shouldRunNuGet=false 2>&1

if ($LastExitCode -ne 0) {
    Set-Content c:/vagrant/buildOutput.log -Value $CakeOutput
    Write-Host "The build has failed. Please see the buildOutput.log file for details"
    exit $LastExitCode
}

Write-Host "($(Get-Date -Format "dddd MM/dd/yyyy HH:mm:ss K")) Build complete."
