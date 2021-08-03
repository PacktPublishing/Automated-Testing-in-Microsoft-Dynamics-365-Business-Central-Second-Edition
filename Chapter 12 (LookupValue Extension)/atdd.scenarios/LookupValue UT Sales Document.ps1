Feature 'LookupValue UT Sales Document' {
    Scenario 0004 'Assign lookup value to sales header' {
        Given 'Lookup value'
        Given 'Sales header'
        When 'Set lookup value on sales header'
        Then 'Sales header has lookup value code field populated' 
    }

    Scenario 0005 'Assign non-existing lookup value on sales header' {
        Given 'Non-existing lookup value'
        Given 'Sales header record variable'
        When 'Set non-existing lookup value to sales header'
        Then 'Non existing lookup value error was thrown'
    }

    Scenario 0006 'Assign lookup value on sales quote document page' {
        Given 'Lookup value'
        Given 'Sales quote document page'
        When 'Set lookup value on sales quote document'
        Then 'Sales quote has lookup value code field populated' 
    }

    Scenario 0007 'Assign lookup value on sales order document page' {
        Given 'Lookup value'
        Given 'Sales order document page'
        When 'Set lookup value on sales order document'
        Then 'Sales order has lookup value code field populated'
    }

    Scenario 0008 'Assign lookup value on sales invoice document page' {
        Given 'Lookup value'
        Given 'Sales invoice document page'
        When 'Set lookup value on sales invoice document'
        Then 'Sales invoice has lookup value code field populated' 
    }

    Scenario 0009 'Assign lookup value on sales credit memo document page' {
        Given 'Lookup value'
        Given 'Sales credit memo document page'
        When 'Set lookup value on sales credit memo document'
        Then 'Sales credit memo has lookup value code field populated' 
    }

    Scenario 0010 'Assign lookup value on sales return order document page' {
        Given 'Lookup value'
        Given 'Sales return order document page'
        When 'Set lookup value on sales return order document'
        Then 'Sales return order has lookup value code field populated'
    }

    Scenario 0011 'Assign lookup value on blanket sales order document page' {
        Given 'Lookup value'
        Given 'Blanket sales order document page'
        When 'Set lookup value on blanket sales order document'
        Then 'Blanket sales order has lookup value code field populated'
    }
}   