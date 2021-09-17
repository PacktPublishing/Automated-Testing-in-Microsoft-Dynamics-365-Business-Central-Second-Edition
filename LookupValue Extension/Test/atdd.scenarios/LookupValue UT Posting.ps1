Feature 'LookupValue UT Posting' {
    Scenario 0100 'Check failure OnBeforePostSalesDocEvent subscriber' {
        Given 'Sales header without lookup value'
        When 'Trigger OnBeforePostSalesDocEvent'
        Then 'Missing lookup value on sales header error thrown'
    }

    Scenario 0101 'Check success OnBeforePostSalesDocEvent subscriber' {
        Given 'Sales header with lookup value'
        When 'Trigger OnBeforePostSalesDocEvent'
        Then 'No error thrown'
    }

    Scenario 0102 'Check failure OnBeforePostSourceDocumentEvent subscriber' {
        Given 'Sales header with number and without lookup value'
        When 'Trigger OnBeforePostSourceDocumentEvent'
        Then 'Missing lookup value on sales header error thrown'
    }
    Scenario 0103 'Check success OnBeforePostSourceDocumentEvent subscriber' {
        Given 'Sales header with number and lookup value'
        When 'Trigger OnBeforePostSourceDocumentEvent'
        Then 'No error thrown'
    }
}
    