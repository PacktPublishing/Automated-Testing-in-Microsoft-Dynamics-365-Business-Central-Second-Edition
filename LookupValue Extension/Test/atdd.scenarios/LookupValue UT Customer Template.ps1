Feature 'LookupValue Customer Template' {
    Scenario 0012 'Assign lookup value to customer template' {
        Given 'Lookup value'
        Given 'Customer template'
        When 'Set lookup value on customer template'
        Then 'Customer template has lookup value code field populated'
    }

    Scenario 0013 'Assign non-existing lookup value to customer template' {
        Given 'Non-existing lookup value'
        Given 'Customer template record variable'
        When 'Set non-existing lookup value to customer template'
        Then 'Non existing lookup value error was thrown'
    }

    Scenario 0014 'Assign lookup value on customer template card' {
        Given 'Lookup value'
        Given 'Customer template card'
        When 'Set lookup value on customer template card'
        Then 'Customer template has lookup value code field populated'
    }
}    