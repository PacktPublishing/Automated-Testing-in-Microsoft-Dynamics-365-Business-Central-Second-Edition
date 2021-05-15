& "./atdd.scenarios/LookupValue UT Customer.ps1" | `
    ConvertTo-ALTestCodeunit `
        -CodeunitID 81000 `
        -CodeunitName 'LookupValue UT Customer' `
        -InitializeFunction `
        -GivenFunctionName "Create {0}" `
        -ThenFunctionName "Verify {0}" `
        | Out-File '.\test\LookupValueUTCustomer_2.Codeunit.al'