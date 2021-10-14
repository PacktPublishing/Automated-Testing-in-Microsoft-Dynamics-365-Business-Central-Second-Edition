Feature 'LookupValue UT Posting' {
    Scenario 0100 'Check failure CheckLookupvalueExistsOnSalesHeader Sales Posting' {
        Given 'Sales header without lookup value'
        When 'Trigger CheckLookupvalueExistsOnSalesHeader Sales Posting'
        Then 'Missing lookup value on sales header error thrown'
    }

    Scenario 0101 'Check success CheckLookupvalueExistsOnSalesHeader Sales Posting' {
        Given 'Sales header with lookup value'
        When 'Trigger CheckLookupvalueExistsOnSalesHeader Sales Posting'
        Then 'No error thrown' 
    }

    Scenario 0102 'Check failure CheckLookupvalueExistsOnSalesHeader Whse. Posting' {
        Given 'Sales header with number and without lookup value'
        When 'Trigger CheckLookupvalueExistsOnSalesHeader Whse. Posting'
        Then 'Missing lookup value on sales header error thrown'
    }

    Scenario 0103 'Check success CheckLookupvalueExistsOnSalesHeader Whse. Posting' {
        Given 'Sales header with number and lookup value'
        When 'Trigger CheckLookupvalueExistsOnSalesHeader Whse. Posting'
        Then 'No error thrown' 
    } 
}    