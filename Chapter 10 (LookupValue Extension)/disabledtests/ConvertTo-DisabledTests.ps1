param(
    [Parameter()]
    [String] $inputFolderPath = '',

    [Parameter()]
    [String] $inputFileName = 'TestResults.xml',

    [Parameter()]
    [string] $outputFileName = 'DisabledTests.json'
)

write-host "ConvertTo-DisabledTests"
$inputFilePath = join-path $inputFolderPath $inputFileName
write-host "Input file: $inputFilePath"
$outputFilePath = join-path $inputFolderPath $outputFileName
write-host "Output file: $outputFilePath"

$disabledTestsJSON = @()
$results = [xml](Get-Content -Path $inputFilePath)
$results.SelectNodes('//test') | `
    Where-Object { $_.Result -ne "Pass" } | `
    ForEach-Object { $disabledTestsJSON += `
        [ordered]@{ "codeunitId" = $_.ParentNode.ParentNode.name -replace '^(\d+)\s.*$', '$1' -as[int]; "codeunitName" = $_.name.Split(':')[0]; "method" = $_.method } }

$disabledTestsJSON | ConvertTo-Json -Depth 99 | Set-Content $outputFilePath