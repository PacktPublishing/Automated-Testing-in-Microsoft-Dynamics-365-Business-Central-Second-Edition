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
    procedure CheckFailureOnBeforePostSalesDocEventSubscriber()
    //[FEATURE] LookupValue UT Posting Sales Document
    var
        SalesHeader: Record "Sales Header";
    begin
        // [SCENARIO #0100] Check failure OnBeforePostSalesDocEvent subscriber

        // [GIVEN] Sales header without lookup value
        // See local variable SalesHeader

        // [WHEN] Trigger OnBeforePostSalesDocEvent
        asserterror TriggerOnBeforePostSalesDocEvent(SalesHeader);

        // [THEN] Missing lookup value on sales header error thrown
        VerifyMissingLookupValueOnSalesHeaderErrorThrown(SalesHeader);
    end;

    [Test]
    procedure CheckSuccessOnBeforePostSalesDocEventSubscriber()
    //[FEATURE] LookupValue UT Posting Sales Document
    var
        SalesHeader: Record "Sales Header";
    begin
        // [SCENARIO #0101] Check success OnBeforePostSalesDocEvent subscriber

        // [GIVEN] Sales header with lookup value
        SalesHeader."Lookup Value Code" := 'SC #0101';

        // [WHEN] Trigger OnBeforePostSalesDocEvent
        TriggerOnBeforePostSalesDocEvent(SalesHeader);

        // [THEN] No error thrown
        VerifyNoErrorThrown();
    end;

    [Test]
    procedure CheckFailureOnBeforePostSourceDocumentEventSubscriber()
    // [FEATURE] LookupValue UT Posting Warehouse Shipment
    var
        SalesHeader: Record "Sales Header";
    begin
        // [SCENARIO #0102] Check failure OnBeforePostSourceDocumentEvent subscriber

        // [GIVEN] Sales header with number and without lookup value
        SalesHeader."No." := 'SC #0102';

        // [WHEN] Trigger OnBeforePostSourceDocumentEvent
        asserterror TriggerOnBeforePostSourceDocumentEvent(SalesHeader);

        // [THEN] Missing lookup value on sales header error thrown
        VerifyMissingLookupValueOnSalesHeaderErrorThrown(SalesHeader);
    end;

    [Test]
    procedure CheckSuccessOnBeforePostSourceDocumentEventSubscriber()
    // [FEATURE] LookupValue UT Posting Warehouse Shipment
    var
        SalesHeader: Record "Sales Header";
    begin
        // [SCENARIO #0103] Check success OnBeforePostSourceDocumentEvent subscriber

        // [GIVEN] Sales header with number and lookup value
        SalesHeader."No." := 'SC #0103';
        SalesHeader."Lookup Value Code" := 'SC #0103';

        // [WHEN] Trigger OnBeforePostSourceDocumentEvent
        TriggerOnBeforePostSourceDocumentEvent(SalesHeader);

        // [THEN] No error thrown
        VerifyNoErrorThrown();
    end;

    local procedure TriggerOnBeforePostSalesDocEvent(SalesHeader: Record "Sales Header")
    var
        SalesPostEvents: Codeunit SalesPostEvents;
    begin
        SalesPostEvents.OnBeforePostSalesDocEvent(SalesHeader)
    end;

    local procedure TriggerOnBeforePostSourceDocumentEvent(SalesHeader: Record "Sales Header")
    var
        WhseShptLine: Record "Warehouse Shipment Line";
        PurchaseHeader: Record "Purchase Header";
        TransferHeader: Record "Transfer Header";
        WhsePostShipmentEvents: Codeunit WhsePostShipmentEvents;
    begin
        WhsePostShipmentEvents.OnBeforePostSourceDocumentEvent(WhseShptLine, PurchaseHeader, SalesHeader, TransferHeader);
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