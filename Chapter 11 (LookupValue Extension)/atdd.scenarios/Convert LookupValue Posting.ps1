& "./atdd.scenarios/LookupValue Posting.ps1" | `
    ConvertTo-ALTestCodeunit `
        -CodeunitID 81005 `
        -CodeunitName 'LookupValue Posting' `
        -InitializeFunction `
        -GivenFunctionName "Create {0}" `
        -ThenFunctionName "Verify {0}" `
        | Out-File '.\test\LookupValuePosting_2.Codeunit.al'