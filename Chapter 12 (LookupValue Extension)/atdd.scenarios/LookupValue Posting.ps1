Feature 'LookupValue Posting' {
    Scenario 0022 'Check that posted sales invoice and shipment inherit lookup value from sales order' {
        Given 'Sales order with Lookup value'
        When 'Sales order is posted (invoice & ship)'
        Then 'Posted sales invoice has lookup value from sales order'
        Then 'Sales shipment has lookup value from sales order'
    }

    Scenario 0027 'Check posting throws error on sales order with empty lookup value' {
        Given 'Sales order without Lookup value'
        When 'Sales order is posted (invoice & ship)'
        Then 'Missing lookup value on sales order error thrown'
    }

    Scenario 0023 'Check that posted warehouse shipment line inherits lookup value from sales order through warehouse shipment line' {
        Given 'Location with require shipment'
        Given 'Warehouse employee for current user'
        Given 'Warehouse shipment line with Lookup value created from Sales order'
        When 'Warehouse shipment is posted'
        Then 'Posted warehouse shipment line has lookup value from warehouse shipment line'
    }

    Scenario 0025 'Check posting throws error on sales order with empty lookup value' {
        Given 'Location with require shipment'
        Given 'Warehouse employee for current user'
        Given 'Warehouse shipment line created from Sales order without  lookup value'
        When 'Warehouse shipment is posted'
        Then 'Missing lookup value on sales order error thrown'
    }
}    