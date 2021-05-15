& "./atdd.scenarios/LookupValue Inheritance.ps1" | `
    ConvertTo-ALTestCodeunit `
        -CodeunitID 81006 `
        -CodeunitName 'LookupValue Inheritance' `
        -InitializeFunction `
        -GivenFunctionName "Create {0}" `
        -ThenFunctionName "Verify {0}" `
        | Out-File '.\test\LookupValueInheritance_2.Codeunit.al'