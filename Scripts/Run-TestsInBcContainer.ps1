# set container name and version
$containerName = 'your-container-name'

# set credentials for Windows usage
$login = 'your-windows-user-name'
$password = 'your-password'
$securepassword = ConvertTo-SecureString -String $password -AsPlainText -Force
$credential = New-Object PSCredential($login, $securepassword)

Run-TestsInBcContainer -containerName $containerName `
                       -credential $credential `
                       -extensionId 'e26890f8-fafe-49c6-8951-2c1457921f9b' `                       -detailed `                       -testPage 130455 `                       -testRunnerCodeunitId 130451