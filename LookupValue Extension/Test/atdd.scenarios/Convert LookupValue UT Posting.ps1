& "./atdd.scenarios/LookupValue UT Posting.ps1" | `
    ConvertTo-ALTestCodeunit `
        -CodeunitID 81025 `
        -CodeunitName 'LookupValue UT Posting' `
        -GivenFunctionName "Create {0}" `
        -ThenFunctionName "Verify {0}" `
        | Out-File '.\test\LookupValueUTPosting_2.Codeunit.al'