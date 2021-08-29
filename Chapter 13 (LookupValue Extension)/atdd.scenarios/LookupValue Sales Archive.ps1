Feature 'LookupValue Sales Archive' {
    Scenario 0018 'Archive sales order with lookup value' {
        Given 'Sales order with Lookup value'
        When 'Sales order is archived'
        Then 'Archived sales order has lookup value from sales order'
    }

    Scenario 0019 'Archive sales quote with lookup value' {
        Given 'Sales quote with Lookup value'
        When 'Sales quote is archived'
        Then 'Archived sales quote has lookup value from sales quote'
    }

    Scenario 0020 'Archive sales return order with lookup value' {
        Given 'Sales return order with Lookup value'
        When 'Sales return order is archived'
        Then 'Archived sales return order has lookup value from sales return order'
    }

    Scenario 0021 'Check that lookup value is shown right on Sales List Archive' {
        Given 'Sales document with Lookup value'
        When 'Sales document is archived'
        Then 'Archived sales document has lookup value from sales document'
        Then 'lookup value is shown right on Sales List Archive'
    }
}    