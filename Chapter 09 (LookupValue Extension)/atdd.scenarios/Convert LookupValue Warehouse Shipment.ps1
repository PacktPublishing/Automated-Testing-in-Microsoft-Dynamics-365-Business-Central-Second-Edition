& "./atdd.scenarios/LookupValue Warehouse Shipment.ps1" | `
    ConvertTo-ALTestCodeunit `
        -CodeunitID 81003 `
        -CodeunitName 'LookupValue Warehouse Shipment' `
        -InitializeFunction `
        -GivenFunctionName "Create {0}" `
        -ThenFunctionName "Verify {0}" `
        | Out-File '.\test\LookupValueWarehouseShipment_2.Codeunit.al'