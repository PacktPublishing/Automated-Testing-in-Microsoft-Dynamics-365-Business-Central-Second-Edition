Feature 'LookupValue Permissions' {
    Scenario 0041 'Create lookup value without permissions' {
        Given 'Full base starting permissions'
        When 'Create lookup value'
        Then 'Insert permissions error thrown' 
    }

    Scenario 0042 'Create lookup value with permissions' {
        Given 'Full base starting permissions extended with Lookup Value permissions'
        When 'Create lookup value'
        Then 'Lookup value exists' 
    }

    Scenario 0043 'Read lookup value without permissions' {
        Given 'Unrestricted starting permissions'
        Given 'Lookup Value'
        Given 'Full base permissions'
        When 'Read lookup value'
        Then 'Read permissions error thrown' 
    }

    Scenario 0044 'Read lookup value with permissions' {
        Given 'Unrestricted starting permissions'
        Given 'Lookup Value'
        Given 'Full base permissions extended with Lookup Value'
        When 'Read lookup value'
        Then 'Lookup value exists' 
    }

    Scenario 0045 'Modify lookup value without permissions' {
        Given 'Unrestricted starting permissions'
        Given 'Lookup Value'
        Given 'Full base permissions'
        When 'Modify lookup value'
        Then 'Modify permissions error thrown' 
    }

    Scenario 0046 'Modify lookup value with permissions' {
        Given 'Unrestricted starting permissions'
        Given 'Lookup Value'
        Given 'Full base permissions extended with Lookup Value'
        When 'Modify lookup value'
        Then 'Lookup value exists' 
    }

    Scenario 0047 'Delete lookup value without permissions' {
        Given 'Unrestricted starting permissions'
        Given 'Lookup Value'
        Given 'Full base permissions'
        When 'Delete lookup value'
        Then 'Delete permissions error thrown' 
    }

    Scenario 0048 'Delete lookup value with permissions' {
        Given 'Unrestricted starting permissions'
        Given 'Lookup Value'
        Given 'Full base permissions extended with Lookup Value'
        When 'Delete lookup value'
        Then 'Lookup value does not exist' 
    }

    Scenario 0049 'Open Lookup Values Page without permissions' {
        Given 'Unrestricted starting permissions'
        Given 'Lookup value'
        Given 'Full base permissions'
        When 'Open Lookup Values page'
        Then 'Read permissions error thrown' 
    }

    Scenario 0050 'Open Lookup Values Page with permissions' {
        Given 'Full base permissions extended with Lookup Value'
        Given 'Clear last error'
        When 'Open Lookup Values page'
        Then 'No error thrown' 
    }

    Scenario 0051 'Check lookup value on customer card without permissions' {
        Given 'Full base starting permissions'
        When 'Open customer card'
        Then 'Lookup value field not shown' 
    }

    Scenario 0052 'Check lookup value on customer card with permissions' {
        Given 'Full base starting permissions extended with Lookup Value permissions'
        When 'Open customer card'
        Then 'Lookup value field shown' 
    }

    Scenario 0053 'Check lookup value on customer list without permissions' {
        Given 'Full base starting permissions'
        When 'Open customer list'
        Then 'Lookup value field not shown' 
    }

    Scenario 0054 'Check lookup value on customer list with permissions' {
        Given 'Full base starting permissions extended with Lookup Value permissions'
        When 'Open customer list'
        Then 'Lookup value field shown'
    }
}    