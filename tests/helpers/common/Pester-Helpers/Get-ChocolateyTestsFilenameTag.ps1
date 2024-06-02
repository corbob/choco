function Get-ChocolateyTestsFilenameTag {
    param(
        $Invocation = $MyInvocation
    )
    (Get-Item $Invocation.ScriptName).BaseName
}
