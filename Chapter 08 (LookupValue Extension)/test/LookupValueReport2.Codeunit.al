codeunit 81009 "LookupValue Report 2"
{
    Subtype = Test;

    trigger OnRun()
    begin
        //[FEATURE] LookupValue Report
    end;

    var
        LibrarySales: Codeunit "Library - Sales";
        LibraryReportDataset: Codeunit "Library - Report Dataset";
        LibraryLookupValue: Codeunit "Library - Lookup Value";
        isInitialized: Boolean;

    [Test]
    [HandlerFunctions('CustomerListRequestPageHandler')]
    procedure TestLookupValueShowsOnStandardCustomerListReport();
    //[FEATURE] LookupValue Report
    var
        Customer: array[2] of Record Customer;
    begin
        //[SCENARIO #0032] Test that lookup value shows on standard Customer - List report
        Initialize();

        //[GIVEN] 2 customers with different lookup value
        CreateCustomerWithLookupValue(Customer[1]);
        CreateCustomerWithLookupValue(Customer[2]);

        //[WHEN] Run standard report Customer - List
        CommitAndRunReportCustomerList();

        //[THEN] Report dataset contains both customers with lookup value
        VerifyCustomerWithLookupValueOnCustomerListReport(Customer[1]."No.", Customer[1]."Lookup Value Code");
        VerifyCustomerWithLookupValueOnCustomerListReport(Customer[2]."No.", Customer[2]."Lookup Value Code");
    end;

    local procedure Initialize()
    var
        Customer: Record Customer;
    begin
        if isInitialized then
            exit;

        isInitialized := true;
        Commit();
    end;

    local procedure CreateCustomerWithLookupValue(var Customer: Record Customer)
    begin
        LibrarySales.CreateCustomer(Customer);
        Customer.Validate("Lookup Value Code", CreateLookupValueCode());
        Customer.Modify();
    end;

    local procedure CreateLookupValueCode(): Code[10]
    begin
        exit(LibraryLookupValue.CreateLookupValueCode())
    end;

    local procedure CommitAndRunReportCustomerList()
    var
        RequestPageXML: Text;
    begin
        Commit(); // close open write transaction to be able to run the report

        RequestPageXML := Report.RunRequestPage(Report::"Customer - List", RequestPageXML);
        LibraryReportDataset.RunReportAndLoad(Report::"Customer - List", '', RequestPageXML);
    end;

    local procedure VerifyCustomerWithLookupValueOnCustomerListReport(No: Code[20]; LookupValueCode: Code[10])
    begin
        LibraryReportDataset.AssertElementWithValueExists('Customer__No__', No);
        LibraryReportDataset.AssertElementWithValueExists('Customer_Lookup_Value_Code', LookupValueCode);
    end;

    [RequestPageHandler]
    procedure CustomerListRequestPageHandler(var CustomerListRequestPage: TestRequestPage "Customer - List")
    begin
        // Empty handler used to close the request page, default settings are used
    end;
}