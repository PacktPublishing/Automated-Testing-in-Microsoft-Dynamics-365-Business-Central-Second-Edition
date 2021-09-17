Feature 'LookupValue UT API' {
    Scenario 0200 'Get lookup value' {
        Given 'Committed lookup value'
        When 'Send GET request for lookup value'
        Then 'Lookup value in response'
    }

    Scenario 0201 'Delete lookup value' {
        Given 'Committed lookup value'
        When 'Send DELETE request for lookup value'
        Then 'Empty response'
        Then 'Lookup value deleted from database' 
    }

    Scenario 0202 'Modify lookup value' {
        Given 'Committed lookup value'
        Given 'Updated lookup value JSON object'
        When 'Send PATCH request for lookup value JSON object'
        Then 'Updated lookup value in response'
        Then 'Updated lookup value in database' 
    }

    Scenario 0203 'Create lookup value' {
        Given 'Lookup value JSON object'
        When 'Send POST request for lookup value JSON object'
        Then 'New lookup value in response'
        Then 'New lookup value in database'
    }
}