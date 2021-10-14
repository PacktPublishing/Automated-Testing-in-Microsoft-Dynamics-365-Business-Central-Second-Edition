codeunit 81025 "LookupValue UT Posting"
{
    // Generated on 5-8-2021 at 10:21 by lvanvugt

    Subtype = Test;

    trigger OnRun()
    begin
        // [FEATURE] LookupValue UT Posting
    end;

    var
        Assert: Codeunit "Library Assert";

    [Test]
    procedure CheckFailureCheckLookupvalueExistsOnSalesHeaderSalesPosting()
    //[FEATURE] LookupValue UT Posting Sales Document
    var
        SalesHeader: Record "Sales Header";
    begin
        // [SCENARIO #0100] Check failure CheckLookupvalueExistsOnSalesHeader Sales Posting

        // [GIVEN] Sales header without lookup value
        // See local variable SalesHeader

        // [WHEN] Trigger CheckLookupvalueExistsOnSalesHeader Sales Posting
        asserterror TriggerCheckLookupvalueExistsOnSalesHeaderSalesPosting(SalesHeader);

        // [THEN] Missing lookup value on sales header error thrown
        VerifyMissingLookupValueOnSalesHeaderErrorThrown(SalesHeader);
    end;

    [Test]
    procedure CheckSuccessCheckLookupvalueExistsOnSalesHeaderSalesPosting()
    //[FEATURE] LookupValue UT Posting Sales Document
    var
        SalesHeader: Record "Sales Header";
    begin
        // [SCENARIO #0101] Check success CheckLookupvalueExistsOnSalesHeader Sales Posting

        // [GIVEN] Sales header with lookup value
        SalesHeader."Lookup Value Code" := 'SC #0101';

        // [WHEN] Trigger CheckLookupvalueExistsOnSalesHeader Sales Posting
        TriggerCheckLookupvalueExistsOnSalesHeaderSalesPosting(SalesHeader);

        // [THEN] No error thrown
        VerifyNoErrorThrown();
    end;

    [Test]
    procedure CheckFailureCheckLookupvalueExistsOnSalesHeaderWhsePosting()
    // [FEATURE] LookupValue UT Posting Warehouse Shipment
    var
        SalesHeader: Record "Sales Header";
    begin
        // [SCENARIO #0102] Check failure CheckLookupvalueExistsOnSalesHeader Whse. Posting

        // [GIVEN] Sales header with number and without lookup value
        SalesHeader."No." := 'SC #0102';

        // [WHEN] Trigger CheckLookupvalueExistsOnSalesHeader Whse. Posting
        asserterror TriggerCheckLookupvalueExistsOnSalesHeaderWhsePosting(SalesHeader);

        // [THEN] Missing lookup value on sales header error thrown
        VerifyMissingLookupValueOnSalesHeaderErrorThrown(SalesHeader);
    end;

    [Test]
    procedure CheckSuccessCheckLookupvalueExistsOnSalesHeaderWhsePosting()
    // [FEATURE] LookupValue UT Posting Warehouse Shipment
    var
        SalesHeader: Record "Sales Header";
    begin
        // [SCENARIO #0103] Check success CheckLookupvalueExistsOnSalesHeader Whse. Posting

        // [GIVEN] Sales header with number and lookup value
        SalesHeader."No." := 'SC #0103';
        SalesHeader."Lookup Value Code" := 'SC #0103';

        // [WHEN] Trigger CheckLookupvalueExistsOnSalesHeader Whse. Posting
        TriggerCheckLookupvalueExistsOnSalesHeaderWhsePosting(SalesHeader);

        // [THEN] No error thrown
        VerifyNoErrorThrown();
    end;

    local procedure TriggerCheckLookupvalueExistsOnSalesHeaderSalesPosting(SalesHeader: Record "Sales Header")
    var
        SalesPostEvents: Codeunit SalesPostEvents;
    begin
        SalesPostEvents.CheckLookupvalueExistsOnSalesHeader(SalesHeader)
    end;

    local procedure TriggerCheckLookupvalueExistsOnSalesHeaderWhsePosting(SalesHeader: Record "Sales Header")
    var
        WhsePostShipmentEvents: Codeunit WhsePostShipmentEvents;
    begin
        WhsePostShipmentEvents.CheckLookupvalueExistsOnSalesHeader(SalesHeader);
    end;

    local procedure VerifyMissingLookupValueOnSalesHeaderErrorThrown(SalesHeader: Record "Sales Header")
    var
        LibraryMessages: Codeunit "Library - Messages";
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