function Invoke-ChocoSnapshotTest {
    <#
        .Synopsis
            Helper function to call chocolatey with any number of specified arguments,
            and return a hashtable with the output as well as the exit code.
    #>
    [CmdletBinding()]
    param(
        # The arguments to use when calling the Choco executable
        [Parameter(Position = 1, ValueFromRemainingArguments)]
        [string[]]$Arguments,
        [Parameter()]
        [string]$TestId
    )
    $differs = $false
    $file = "$TestId.xml"
    $baselineDir = Join-Path $PSScriptRoot 'baseline'
    $currentDir = Join-Path $PSScriptRoot 'current'
    $baselineFile = Join-Path $baselineDir $file
    $currentFile = Join-Path $currentDir $file
    $null = mkdir $baselineDir -ErrorAction SilentlyContinue
    $null = mkdir $currentDir -ErrorAction SilentlyContinue

    $thisRun = Invoke-Choco @Arguments
    $thisRun | Export-Clixml $currentFile

    if (Test-Path $baselineFile) {
        $lastRun = Import-Clixml $baselineFile
    } else {
        throw "No baseline for $TestId"
    }


    if ([math]::abs(($lastRun.Duration - $thisRun.Duration).totalMilliseconds) -gt 250) {
        Write-Warning "Run discrepancy of greater than 250 ms"
        Write-Warning "Baseline: $($lastRun.Duration)"
        Write-Warning "Current: $($thisRun.Duration)"
        # $differs = $true
    }
    $ignoredRegex = @(
        'Chocolatey v\d.*'
        'Chocolatey has determined \d+ package\(s\) are outdated\.'
    )
    $comparison = Compare-Object $lastRun.Lines $thisRun.Lines | ? { $_.InputObject -notmatch $(($ignoredRegex | % { "($_)" }) -join '|') } | Select-Object @{n = 'Line'; e = { $_.InputObject } }, @{n = 'Run'; e = { if ($_.SideIndicator -eq '=>') { 'current' } else { 'baseline' } } } | sort Run

    if ($comparison) {
        Write-Warning "Strings do not match..."
        Write-Warning ($comparison | Out-String)
        $differs = $true
    }

    if ($differs) {
        throw "Current run differs from the baseline. If this is acceptable, replace the baseline file with the current file."
    }
    $thisRun
}
