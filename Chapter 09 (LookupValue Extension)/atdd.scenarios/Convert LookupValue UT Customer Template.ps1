& "./atdd.scenarios/LookupValue UT Customer Template.ps1" | `
    ConvertTo-ALTestCodeunit `
        -CodeunitID 81002 `
        -CodeunitName 'LookupValue UT Cust. Template' `
        -InitializeFunction `
        -GivenFunctionName "Create {0}" `
        -ThenFunctionName "Verify {0}" `
        | Out-File '.\test\LookupValueUTCustTemplate_2.Codeunit.al'