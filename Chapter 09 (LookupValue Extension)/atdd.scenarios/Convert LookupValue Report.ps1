& "./atdd.scenarios/LookupValue Report.ps1" | `
    ConvertTo-ALTestCodeunit `
        -CodeunitID 81008 `
        -CodeunitName 'LookupValue Report' `
        -InitializeFunction `
        -GivenFunctionName "Create {0}" `
        -ThenFunctionName "Verify {0}" `
        | Out-File '.\test\LookupValueReport_2.Codeunit.al'