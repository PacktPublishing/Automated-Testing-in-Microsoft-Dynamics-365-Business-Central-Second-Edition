& "./atdd.scenarios/LookupValue Permissions.ps1" | `
    ConvertTo-ALTestCodeunit `
        -CodeunitID 81020 `
        -CodeunitName 'LookupValue Permissions' `
        -InitializeFunction `
        -GivenFunctionName "Create {0}" `
        -ThenFunctionName "Verify {0}" `
        | Out-File '.\test\LookupValuePermissions_2.Codeunit.al'