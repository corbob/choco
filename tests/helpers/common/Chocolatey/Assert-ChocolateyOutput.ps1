function Assert-ChocolateyOutput {
    param(
        [Parameter()]
        $Output,
        [Parameter()]
        [int[]]
        $ExpectedExitCode
    )
    $Output.ExitCode | Should -BeIn $ExpectedExitCode -Because $Output.String
}
