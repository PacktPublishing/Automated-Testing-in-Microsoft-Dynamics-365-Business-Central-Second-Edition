Feature 'LookupValue Warehouse Shipment' {
    Scenario 0015 'Assign lookup value to warehouse shipment line' {
        Given 'Lookup value'
        Given 'Location with require shipment'
        Given 'Warehouse employee for current user'
        Given 'Warehouse shipment from released sales order with line with require shipment location'
        When 'Set lookup value on warehouse shipment line'
        Then 'Warehouse shipment line has lookup value code field populated'
    }

    Scenario 0016 'Assign non-existing lookup value on warehouse shipment line' {
        Given 'Non-existing lookup value'
        Given 'Warehouse shipment line record variable'
        When 'Set non-existing lookup value to warehouse shipment line'
        Then 'Non existing lookup value error was thrown'
    }

    Scenario 0017 'Assign lookup value to warehouse shipment line on warehouse shipment document page' {
        Given 'Lookup value'
        Given 'Location with require shipment'
        Given 'Warehouse employee for current user'
        Given 'Warehouse shipment from released sales order with line with require shipment location'
        When 'Set lookup value on warehouse shipment line on warehouse shipment document page'
        Then 'Warehouse shipment line has lookup value code field populated'
    }

    Scenario 0030 'Create warehouse shipment from sales order with lookup value' {
        Given 'Lookup value'
        Given 'Location with require shipment'
        Given 'Warehouse employee for current user'
        When 'Create warehouse shipment from released sales order with lookup value and with line with require shipment location'
        Then 'Warehouse shipment line has lookup value code field populated'
    }

    Scenario 0031 'Get sales order with lookup value on warehouse shipment' {
        Given 'Lookup value'
        Given 'Location with require shipment'
        Given 'Warehouse employee for current user'
        Given 'Released sales order with lookup value and with line with require shipment location'
        Given 'Warehouse shipment without lines'
        When 'Get sales order with lookup value on warehouse shipment'
        Then 'Warehouse shipment line has lookup value code field populated'
    }
}    