Feature 'LookupValue Inheritance' {
    Scenario 0024 'Assign customer lookup value to sales document' {
        Given 'Customer with Lookup value'
        Given 'Sales document (invoice) without Lookup value'
        When 'Set customer on sales header'
        Then 'Lookup value on sales document is populated with lookup value of customer'
    }

    Scenario 0026 'Check that lookup value is inherited from customer template to customer when creating customer from contact' {
        Given 'Customer template with lookup value'
        Given 'Contact'
        When 'Customer is created from contact'
        Then 'Customer has lookup value code field populated with lookup value from customer template'
    }

    Scenario 0028 'Create customer from customer template with lookup value' {
        Given 'Customer template with lookup value'
        When 'Create customer card'
        Then 'Lookup value on customer is populated with lookup value of customer template'
    }
}    