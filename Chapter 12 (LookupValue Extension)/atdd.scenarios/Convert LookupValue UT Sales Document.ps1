& "./atdd.scenarios/LookupValue UT Sales Document.ps1" | `
    ConvertTo-ALTestCodeunit `
        -CodeunitID 81001 `
        -CodeunitName 'LookupValue UT Sales Document' `
        -InitializeFunction `
        -GivenFunctionName "Create {0}" `
        -ThenFunctionName "Verify {0}" `
        | Out-File '.\test\LookupValueUTSalesDocument_2.Codeunit.al'