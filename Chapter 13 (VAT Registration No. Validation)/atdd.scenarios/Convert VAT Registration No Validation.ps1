& "./atdd.scenarios/VAT Registration No Validation.ps1" | `
    ConvertTo-ALTestCodeunit `
        -CodeunitID 90000 `
        -CodeunitName 'VAT Reg. No. Validation' `
        -InitializeFunction `
        -GivenFunctionName "Create {0}" `
        -ThenFunctionName "Verify {0}" `
        | Out-File '.\test\VATRegistrationNoValidation_2.Codeunit.al'