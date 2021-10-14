Feature 'LookupValue UT Inheritance' {
    Scenario 0104 'Check InheritLookupValueFromCustomer' {
        Given 'Customer with Lookup value'
        Given 'Sales header without lookup value'
        When 'Trigger InheritLookupValueFromCustomer'
        Then 'Lookup value on sales document is populated with lookup value of customer' 
    }

    Scenario 0105 'Check ApplyLookupValueFromCustomerTemplate from Contact' {
        Given 'Customer template with lookup value'
        Given 'Customer'
        When 'Trigger ApplyLookupValueFromCustomerTemplate'
        Then 'Lookup value on customer is populated with lookup value of customer template' 
    }

    Scenario 0106 'Check ApplyLookupValueFromCustomerTemplate' {
        Given 'Customer template with lookup value'
        Given 'Customer'
        When 'Trigger ApplyLookupValueFromCustomerTemplate'
        Then 'Lookup value on customer is populated with lookup value of customer template'
    }
}    