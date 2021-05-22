Feature 'LookupValue UT Customer' {
    Scenario 0001 'Assign lookup value to customer' {
        Given 'Lookup value'
        Given 'Customer'
        When 'Set lookup value on customer'
        Then 'Customer has lookup value code field populated'
    }

    Scenario 0002 'Assign non-existing lookup value to customer' {
        Given 'Non-existing lookup value'
        Given 'Customer record variable'
        When 'Set non-existing lookup value on customer'
        Then 'Non existing lookup value error thrown'
    }

    Scenario 0003 'Assign lookup value on customer card' {
        Given 'Lookup value'
        Given 'Customer card'
        When 'Set lookup value on customer card'
        Then 'Customer has lookup value code field populated'
    }
}