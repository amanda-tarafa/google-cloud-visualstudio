Param([string]$Configuration, [switch]$FunctionalTests)

if (-not $Configuration) {
    $Configuration = "Release"
}

$testDllNames = "GoogleAnalyticsUtilsTests.dll",
    "GoogleCloudExtensionUnitTests.dll",
    "GoogleCloudExtension.Utils.UnitTests.dll",
    "GoogleCloudExtension.DataSources.UnitTests.dll"

if ($env:APPVEYOR_SCHEDULED_BUILD -or $FunctionalTests) {
    # Don't run functional tests on triggered (PR) builds.
    $testDllNames += "ProjectTemplate.Tests.dll"
}

$testDlls = ls -r -include $testDllNames | ? FullName -Like *\bin\$Configuration\*

$testContainerArgs = $testDlls.FullName -join " "

if ($env:APPVEYOR) {
    $testArgs = $testArgs = "/logger:Appveyor $testContainerArgs /diag:logs\log.txt"
} else {
    $testArgs = $testContainerArgs
}

$testFilters = ($testDlls.BaseName | % { "-[$_]*"}) -join " "

$filter = $testFilters,
    "+[GoogleCloudExtension*]*",
    "+[GoogleAnalyticsUtils*]*",
    "-[*]XamlGeneratedNamespace*",
    "-[*]GoogleCloudExtension*.Resources" -join " "

Write-Verbose "Running OpenCover.Console.exe -register:user -target:vstest.console.exe -targetargs:$testArgs -output:codecoverage.xml `
    -filter:$filter -returntargetcode"

OpenCover.Console.exe -register:user -target:vstest.console.exe -targetargs:$testArgs -output:codecoverage.xml `
    -filter:$filter -returntargetcode

if ($LASTEXITCODE) {   
    Push-AppveyorArtifact logs\log.txt
	Get-ChildItem *\log.*.host.txt | % { Push-AppveyorArtifact $_.FullName -FileName $_.Name }
    throw "Test failed with code $LASTEXITCODE"
}

Push-AppveyorArtifact logs\log.txt
Get-ChildItem *\log.*.host.txt | % { Push-AppveyorArtifact $_.FullName -FileName $_.Name }

Write-Host "Finished code coverage."
