cscript c:/windows/system32/slmgr.vbs /rearm | Out-Null
Set-ExecutionPolicy Bypass -Scope Process -Force
iex (irm https://community.chocolatey.org/install.ps1)

Write-Host "($(Get-Date -Format "dddd MM/dd/yyyy HH:mm:ss K")) We are going to install some prerequisites now. This could take some time"
$null = choco install git pester visualstudio2022community visualstudio2022-workload-manageddesktop netfx-4.8-devpack -y
Import-Module $env:ChocolateyInstall/helpers/chocolateyProfile.psm1
Update-SessionEnvironment
Write-Host "($(Get-Date -Format "dddd MM/dd/yyyy HH:mm:ss K")) Done installing software, now copying files"
# If you try to build on macOS, then run this, there are attributes on some files that cause the build to fail inside of the vagrant environment.
$null = robocopy c:/chocoRoot c:/code/choco /e /copy:dt
