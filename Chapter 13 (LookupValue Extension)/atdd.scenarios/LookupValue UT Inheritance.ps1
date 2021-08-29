Feature 'LookupValue UT Inheritance' {
    Scenario 0104 'Check OnAfterCopySellToCustomerAddressFieldsFromCustomerEvent subscriber' {
        Given 'Customer with Lookup value'
        Given 'Sales header without lookup value'
        When 'Trigger OnAfterCopySellToCustomerAddressFieldsFromCustomerEvent'
        Then 'Lookup value on sales document is populated with lookup value of customer'
    }
    Scenario 0105 'Check OnCreateCustomerFromTemplateOnBeforeCustomerInsertEvent subscriber' {
        Given 'Customer template with lookup value'
        Given 'Customer'
        When 'Trigger OnCreateCustomerFromTemplateOnBeforeCustomerInsertEvent'
        Then 'Lookup value on customer is populated with lookup value of customer template'
    }
    Scenario 0106 'Check OnApplyTemplateOnBeforeCustomerModifyEvent subscriber' {
        Given 'Customer template with lookup value'
        Given 'Customer'
        When 'Trigger OnApplyTemplateOnBeforeCustomerModifyEvent'
        Then 'Lookup value on customer is populated with lookup value of customer template'
    }
}    