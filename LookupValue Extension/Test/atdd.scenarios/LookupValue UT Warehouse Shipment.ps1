Feature 'LookupValue UT Warehouse Shipment' {
    Scenario 0107 'Check InheritLookupValueFromSalesHeader' {
        Given 'Sales header with lookup value'
        Given 'Warehouse shipment line'
        When 'Trigger InheritLookupValueFromSalesHeader'
        Then 'Lookup value on warehouse shipment line is populated with lookup value of sales header'
    } 
}    