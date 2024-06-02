function Assert-ChocolateyOutput {
    param(
        [scriptblock]
        $Assertion,
        [Parameter(ValueFromPipeline)]
        $ChocolateyObject
    )
    $Assertion.InvokeWithContext($null, [psvariable]::new('_', $ChocolateyObject), $null) | Should -BeTrue -Because $ChocolateyObject.String
}
