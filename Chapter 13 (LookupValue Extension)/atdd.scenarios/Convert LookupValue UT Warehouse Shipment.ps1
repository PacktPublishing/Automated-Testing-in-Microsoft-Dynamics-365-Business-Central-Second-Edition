& "./atdd.scenarios/LookupValue UT Warehouse Shipment.ps1" | `
    ConvertTo-ALTestCodeunit `
        -CodeunitID 81023 `
        -CodeunitName 'LookupValue UT Warehouse Shipment' `
        -GivenFunctionName "Create {0}" `
        -ThenFunctionName "Verify {0}" `
        | Out-File '.\test\LookupValueUTWarehouseShipment_2.Codeunit.al'