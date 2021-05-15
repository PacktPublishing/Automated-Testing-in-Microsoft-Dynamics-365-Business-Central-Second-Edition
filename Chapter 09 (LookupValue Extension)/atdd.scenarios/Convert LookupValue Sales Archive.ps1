& "./atdd.scenarios/LookupValue Sales Archive.ps1" | `
    ConvertTo-ALTestCodeunit `
        -CodeunitID 81004 `
        -CodeunitName 'LookupValue Sales Archive' `
        -InitializeFunction `
        -GivenFunctionName "Create {0}" `
        -ThenFunctionName "Verify {0}" `
        | Out-File '.\test\LookupValueSalesArchive_2.Codeunit.al'