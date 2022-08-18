$serverFilePath = "${env:ProgramFiles}\Microsoft Dynamics 365 Business Central\190\Service"

Import-Module "$serverFilePath\Microsoft.Dynamics.Nav.Apps.Management.psd1" -force -DisableNameChecking
Import-Module "$serverFilePath\Microsoft.Dynamics.Nav.Management.psd1" -force -DisableNameChecking

$dvdFilePath = 'place-here-the-filepath-to the-product-dvd-folder'
$bcServerInstance = 'BC190'
$apps = @()

# copy MockTest.dll to server folder
if ((Test-Path "$dvdFilePath\Test Assemblies\Mock Assemblies") -and (Test-Path "$serverFilePath\Add-ins") -and ((Test-Path "$serverFilePath\Add-ins\MockTest.dll") -eq $false)) {
    Copy-Item -Path "$dvdFilePath\Test Assemblies\Mock Assemblies\MockTest.dll" -Destination "$serverFilePath\Add-ins"
    Restart-NAVServerInstance $bcServerInstance
}

# get Test Runner app
if (Test-Path  "$dvdFilePath\Applications\TestFramework\TestRunner") {
    $apps += @(Get-ChildItem -Path "$dvdFilePath\Applications\TestFramework\TestRunner\*.*" -recurse -filter "Microsoft_*.app")
}

# get Test Library apps
if (Test-Path  "$dvdFilePath\Applications\TestFramework\TestLibraries") {
    $apps += @(Get-ChildItem -Path "$dvdFilePath\Applications\TestFramework\TestLibraries\*.*" -recurse -filter "Microsoft_*.app")
}

# get System Test Library app
if (Test-Path  "$dvdFilePath\Applications\system application\Test") {
    $apps += @(Get-ChildItem -Path "$dvdFilePath\Applications\system application\Test\*.*" -recurse -filter "Microsoft_*.app") | Where-Object { $_ -like "*\Microsoft_System Application Test Library.app"}
}

# get System Test app
if (Test-Path  "$dvdFilePath\Applications\system application\Test") {
    $apps += @(Get-ChildItem -Path "$dvdFilePath\Applications\system application\Test\*.*" -recurse -filter "Microsoft_*.app") | Where-Object { $_ -like "*\Microsoft_System Application Test.app"}
}

# get Tests-TestLibraries app
if (Test-Path  "$dvdFilePath\Applications\BaseApp\Test") {
    $apps += @(Get-ChildItem -Path "$dvdFilePath\Applications\BaseApp\Test\*.*" -recurse -filter "Microsoft_*.app") | Where-Object { $_ -like "*\Microsoft_Tests-TestLibraries.app"}
}

## get Library-NoTransactions app / NOTE: Do not default install Library-NoTransactions. This one is used to prevent any transaction from happening, it is used to test that e.g. ugrade is not writing any data on the second run.
#if (Test-Path  "$dvdFilePath\Applications\BaseApp\Test") {
#    $apps += @(Get-ChildItem -Path "$dvdFilePath\Applications\BaseApp\Test\*.*" -recurse -filter "Microsoft_*.app") | Where-Object { $_ -like "*\Microsoft_Library-NoTransactions.app"}
#}

# get Application Test apps
if (Test-Path  "$dvdFilePath\Applications\BaseApp\Test") {
    $apps += @(Get-ChildItem -Path "$dvdFilePath\Applications\BaseApp\Test\*.*" -recurse -filter "Microsoft_*.app") | Where-Object { $_ -notlike "*\Microsoft_Tests-TestLibraries.app" -and $_ -notlike "*\Microsoft_Library-NoTransactions.app" -and $_ -notlike "*\Microsoft_Tests-SINGLESERVER.app" }
}

# publish and install all test apps
$apps | ForEach-Object { 
    Write-Host $_.FullName
    $appInfo = Publish-NAVApp -ServerInstance $bcServerInstance -Path $_.FullName -PassThru
    Write-Host $appInfo.Name
    Sync-NAVApp -ServerInstance $bcServerInstance -Name $appInfo.Name
    Install-NAVApp -ServerInstance $bcServerInstance -Name $appInfo.Name
}
