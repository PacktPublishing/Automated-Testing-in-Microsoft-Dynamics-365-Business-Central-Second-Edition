Feature 'LookupValue Report' {
    Scenario 0029 'Test that lookup value shows on CustomerList report' {
        Given '2 customers with different lookup value'
        When 'Run report CustomerList'
        Then 'Report dataset contains both customers with lookup value'
    }
}    