Feature 'LookupValue Posting' {
    Scenario 0022 'Posted sales invoice and shipment inherit lookup value from sales order' {
        Given 'Sales order with lookup value'
        When 'Post sales order (invoice & ship)'
        Then 'Posted sales invoice has lookup value from sales order'
        Then 'Sales shipment has lookup value from sales order'
    }

    Scenario 0027 'Posting throws error on sales order with empty lookup value' {
        Given 'Sales order without lookup value'
        When 'Post sales order (invoice & ship)'
        Then 'Missing lookup value on sales order error thrown'
    }

    Scenario 0023 'Posted warehouse shipment line inherits lookup value from sales order' {
        Given 'Location with require shipment'
        Given 'Warehouse employee for current user'
        Given 'Warehouse shipment line from sales order with lookup value'
        When 'Post Warehouse shipment'
        Then 'Posted warehouse shipment line has lookup value from sales order'
    }

    Scenario 0025 'Posting throws error on warehouse shipment line with empty lookup value' {
        Given 'Location with require shipment'
        Given 'Warehouse employee for current user'
        Given 'Warehouse shipment line from sales order without lookup value'
        When 'Post Warehouse shipment'
        Then 'Missing lookup value on sales order error thrown'
    }
}    