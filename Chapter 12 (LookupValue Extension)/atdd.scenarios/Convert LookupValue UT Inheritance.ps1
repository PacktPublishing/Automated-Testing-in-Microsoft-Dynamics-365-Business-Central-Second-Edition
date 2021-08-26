& "./atdd.scenarios/LookupValue UT Inheritance.ps1" | `
    ConvertTo-ALTestCodeunit `
        -CodeunitID 81026 `
        -CodeunitName 'LookupValue UT Inheritance' `
        -GivenFunctionName "Create {0}" `
        -ThenFunctionName "Verify {0}" `
        | Out-File '.\test\LookupValueUTInheritance_2.Codeunit.al'