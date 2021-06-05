function ConvertTo-DisabledTests
{
    param(
        [Parameter()]
        [String] $inputFolderPath = '',

        [Parameter()]
        [String] $inputFileName = 'TestResults.xml',

        [Parameter()]
        [string] $outputFileName = 'DisabledTests.json'
    )

    $inputFilePath = join-path $inputFolderPath $inputFileName
    $outputFilePath = join-path $inputFolderPath $outputFileName

    $disabledTestsJSON = @()
    $results = [xml](Get-Content -Path $inputFilePath)
    $results.SelectNodes('//test') | Where-Object { $_.Result -ne "Pass" } | ForEach-Object { $disabledTestsJSON += [ordered]@{ "codeunitName" = $_.name.Split(':')[0]; "method" = $_.method } }

    $disabledTestsJSON | ConvertTo-Json -Depth 99 | Set-Content $outputFilePath
}