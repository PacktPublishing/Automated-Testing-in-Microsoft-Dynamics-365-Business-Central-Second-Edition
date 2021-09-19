& "./atdd.scenarios/LookupValue UT API.ps1" | `
    ConvertTo-ALTestCodeunit `
        -CodeunitID 81090 `
        -CodeunitName 'LookupValue APIV1' `
        -GivenFunctionName "Create {0}" `
        -ThenFunctionName "Verify {0}" `
        | Out-File '.\test\LookupValueUTAPI_2.Codeunit.al'