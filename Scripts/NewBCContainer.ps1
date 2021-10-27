#Install-Module -Name bccontainerhelper -force  

# set accept_eula to $true to accept the eula found here: https://go.microsoft.comfwlink/?linkid=861843
$accept_eula = $true

# set container name and version
$containerName = 'your-container-name'

# set artifact url
$artifactUrl = Get-BCArtifactUrl -country "base" -version "19"

# set credentials for UserPassword usage
$login = 'your-user-name'
$password = 'your-password'
$securepassword = ConvertTo-SecureString -String $password -AsPlainText -Force
$credential = New-Object PSCredential($login, $securepassword)

New-BCContainer -accept_eula:$accept_eula `
                -containerName $containerName `
                -artifactUrl $artifactUrl `
                -auth UserPassword `
                -credential $credential `
                -memoryLimit:10GB `
                -updateHost `
                -shortcuts StartMenu `
                -isolation process `
                -includeTestToolkit `
                -includeTestLibrariesOnly