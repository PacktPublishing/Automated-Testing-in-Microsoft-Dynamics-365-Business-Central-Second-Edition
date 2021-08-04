codeunit 81025 "LookupValue UT Posting"
{
    Subtype = Test;

    trigger OnRun()
    begin
        //[FEATURE] LookupValue UT Posting
    end;

    var
        SalesPostEvents: Codeunit SalesPostEvents;
        Assert: Codeunit "Library Assert";
        LibraryMessages: Codeunit "Library - Messages";

    [Test]
    procedure CheckFailureOnBeforePostSalesDocEvent();
    //[FEATURE] LookupValue UT Posting Sales Document
    var
        SalesHeader: Record "Sales Header";
    begin
        //[SCENARIO #0122] Check failure OnBeforePostSalesDocEvent subscriber

        //[GIVEN] Sales header with no lookup value
        // See local variable SalesHeader

        //[WHEN] OnBeforePostSalesDocEvent is triggered
        asserterror SalesPostEvents.OnBeforePostSalesDocEvent(SalesHeader);

        //[THEN] Missing lookup value on sales header error thrown
        VerifyMissingLookupValueOnSalesHeaderError(SalesHeader);
    end;

    [Test]
    procedure CheckSuccesOnBeforePostSalesDocEvent();
    //[FEATURE] LookupValue UT Posting Sales Document
    var
        SalesHeader: Record "Sales Header";
    begin
        //[SCENARIO #0123] Check succes OnBeforePostSalesDocEvent subscriber

        //[GIVEN] Sales header with 'randon' lookup value
        SalesHeader."Lookup Value Code" := 'SC #0123';

        //[WHEN] OnBeforePostSalesDocEvent is triggered
        SalesPostEvents.OnBeforePostSalesDocEvent(SalesHeader);

        //[THEN] No error thrown
        VerifyNoErrorThrown();
    end;

    local procedure VerifyMissingLookupValueOnSalesHeaderError(SalesHeader: Record "Sales Header")
    begin
        Assert.ExpectedError(
            LibraryMessages.GetFieldMustHaveValueInSalesHeaderTxt(
                SalesHeader.FieldCaption("Lookup Value Code"),
                SalesHeader));
    end;

    local procedure VerifyNoErrorThrown()
    // this smells like duplication ;-) - see test example 9
    begin
        Assert.AreEqual('', GetLastErrorText(), 'No error thrown');
    end;
}