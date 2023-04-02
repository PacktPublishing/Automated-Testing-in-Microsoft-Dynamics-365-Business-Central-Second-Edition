codeunit 81013 "LookupValue Sales Archive 2"
{
    Subtype = Test;
    TestPermissions = Disabled;

    trigger OnRun()
    begin
        //[FEATURE] LookupValue Sales Archive
    end;

    var
        Assert: Codeunit "Library Assert";
        LibrarySales: Codeunit "Library - Sales";
        LibraryLookupValue: Codeunit "Library - Lookup Value";

    [HandlerFunctions('ConfirmArchiveNo,ConfirmArchived')]
    [Test]
    procedure RestoreArchivedSalesOrderWithLookupValueToSalesOrderWithLookupValue()
    var
        SalesHeader: Record "Sales Header";
        LookupValueCode: Code[20];
        NewLookupValueCode: Code[20];
    begin
        //[SCENARIO #0008] Restore archived sales order with lookup value to sales order with new lookup value.

        //[GIVEN] Lookup value
        LookupValueCode := CreateLookupValueCode();
        //[GIVEN] New lookup value
        NewLookupValueCode := CreateLookupValueCode();
        //[GIVEN] Sales order with lookup value.
        CreateDocumentWithLookupValue(SalesHeader, "Sales Document Type"::Order, LookupValueCode);
        //[GIVEN] Archived sales order with lookup value.
        CreateArchivedDocumentFromSalesDocument(SalesHeader."No.", "Sales Document Type"::Order);
        //[GIVEN] Change lookup value on sales order to new lookup value
        ChangeLookupValueCodeForSalesDocument(SalesHeader."No.", NewLookupValueCode, "Sales Document Type"::Order);

        //[WHEN] Restore archived sales order.
        RestoreArchivedDocument(SalesHeader."No.", "Sales Document Type"::Order);

        //[THEN] Sales order has lookup value equals lookup value from the archived sales order.
        VerifySalesHeaderLookupValueEqualsArchivedLookupValue(SalesHeader."Lookup Value Code", LookupValueCode, "Sales Document Type"::Order);
    end;

    [HandlerFunctions('ConfirmArchiveNo,ConfirmArchived')]
    [Test]
    procedure RestoreArchivedSalesOrderWithoutLookupValueToSalesOrderWithLookupValue()
    var
        SalesHeader: Record "Sales Header";
        ArchivedSalesNo: Code[20];
        NewLookupValueCode: Code[20];
    begin
        //[SCENARIO #0009] Restore archived sales order without lookup value to sales order with lookup value.

        //[GIVEN] Lookup value
        NewLookupValueCode := CreateLookupValueCode();
        //[GIVEN] Sales order without lookup value.
        CreateDocumentWithoutLookupValue(SalesHeader, "Sales Document Type"::Order);
        //[GIVEN] Archived sales order with lookup value.
        CreateArchivedDocumentFromSalesDocument(SalesHeader."No.", "Sales Document Type"::Order);
        //[GIVEN] Change lookup value on sales order to new lookup value
        ChangeLookupValueCodeForSalesDocument(SalesHeader."No.", NewLookupValueCode, "Sales Document Type"::Order);

        //[WHEN] Restore archived sales order.
        RestoreArchivedDocument(SalesHeader."No.", "Sales Document Type"::Order);

        //[THEN] Sales order has lookup value equals lookup value from the archived sales order.
        VerifySalesHeaderLookupValueEqualsArchivedLookupValue(SalesHeader."Lookup Value Code", '', "Sales Document Type"::Order);
    end;

    [HandlerFunctions('ConfirmArchiveNo,ConfirmArchived')]
    [Test]
    procedure RestoreArchivedSalesOrderWithLookupValueToSalesOrderWithoutLookupValue()
    var
        SalesHeader: Record "Sales Header";
        ArchivedSalesNo: Code[20];
        LookupValueCode: Code[20];
        NewLookupValueCode: Code[20];
    begin
        //[SCENARIO #0010] Restore archived sales order with lookup value to sales order without lookup value.

        //[GIVEN] Lookup value
        LookupValueCode := CreateLookupValueCode();
        //[GIVEN] New lookUp value
        NewLookupValueCode := '';
        //[GIVEN] Sales order with lookup value.
        CreateDocumentWithLookupValue(SalesHeader, "Sales Document Type"::Order, LookupValueCode);
        //[GIVEN] Archived sales order with lookup value.
        CreateArchivedDocumentFromSalesDocument(SalesHeader."No.", "Sales Document Type"::Order);
        //[GIVEN] Change lookup value on sales order to new lookup value (empty)
        ChangeLookupValueCodeForSalesDocument(SalesHeader."No.", NewLookupValueCode, "Sales Document Type"::Order);

        //[WHEN] Restore archived sales order.
        RestoreArchivedDocument(SalesHeader."No.", "Sales Document Type"::Order);

        //[THEN] Sales order has lookup value equals lookup value from the archived sales order.
        VerifySalesHeaderLookupValueEqualsArchivedLookupValue(SalesHeader."Lookup Value Code", LookupValueCode, "Sales Document Type"::Order);
    end;

    [HandlerFunctions('ConfirmArchiveNo,ConfirmArchived')]
    [Test]
    procedure RestoreArchivedSalesQuoteWithLookupValueToSalesQuoteWithoutLookupValue()
    var
        SalesHeader: Record "Sales Header";
        ArchivedSalesNo: Code[20];
        LookupValueCode: Code[20];
        NewLookupValueCode: Code[20];
    begin
        //[SCENARIO #0011] Restore archived sales quote with lookup value to sales quote without lookup value.

        //[GIVEN] Lookup value
        LookupValueCode := CreateLookupValueCode();
        //[GIVEN] New lookup value
        NewLookupValueCode := '';
        //[GIVEN] Sales quote with lookup value.
        CreateDocumentWithLookupValue(SalesHeader, "Sales Document Type"::"Quote", LookupValueCode);
        //[GIVEN] Archived sales quote with lookup value.
        CreateArchivedDocumentFromSalesDocument(SalesHeader."No.", "Sales Document Type"::Quote);
        //[GIVEN] Change lookup value on sales quote to new lookup value (empty)
        ChangeLookupValueCodeForSalesDocument(SalesHeader."No.", NewLookupValueCode, "Sales Document Type"::Quote);

        //[WHEN] Restore archived sales quote.
        RestoreArchivedDocument(SalesHeader."No.", "Sales Document Type"::Quote);

        //[THEN] Sales quote has lookup value equals lookup value from the archived sales quote.
        VerifySalesHeaderLookupValueEqualsArchivedLookupValue(SalesHeader."Lookup Value Code", LookupValueCode, "Sales Document Type"::Quote);
    end;

    [HandlerFunctions('ConfirmArchiveNo,ConfirmArchived')]
    [Test]
    procedure RestoreArchivedSalesInvoiceWithLookupValueToSalesInvoiceWithoutLookupValue()
    var
        SalesHeader: Record "Sales Header";
        ArchivedSalesNo: Code[20];
        LookupValueCode: Code[20];
        NewLookupValueCode: Code[20];
    begin
        //[SCENARIO #0012] Restore archived sales invoice with lookup value to sales invoice without lookup value.

        //[GIVEN] Lookup value
        LookupValueCode := CreateLookupValueCode();
        //[GIVEN] New lookup value
        NewLookupValueCode := '';
        //[GIVEN] Sales invoice with lookup value.
        CreateDocumentWithLookupValue(SalesHeader, "Sales Document Type"::Invoice, LookupValueCode);
        //[GIVEN] Archived sales invoice with lookup value.
        CreateArchivedDocumentFromSalesDocument(SalesHeader."No.", "Sales Document Type"::Invoice);
        //[GIVEN] Change lookup value on sales invoice to new lookup value (empty)
        ChangeLookupValueCodeForSalesDocument(SalesHeader."No.", NewLookupValueCode, "Sales Document Type"::Invoice);

        //[WHEN] Restore archived sales invoice.
        RestoreArchivedDocument(SalesHeader."No.", "Sales Document Type"::Invoice);

        //[THEN] Sales invoice has lookup value equals lookup value from the archived sales invoice.
        VerifySalesHeaderLookupValueEqualsArchivedLookupValue(SalesHeader."Lookup Value Code", LookupValueCode, "Sales Document Type"::Invoice);
    end;

    [HandlerFunctions('ConfirmArchiveNo,ConfirmArchived')]
    [Test]
    procedure RestoreArchivedDocumentWithLookupValueToBlanketOrderWithoutLookupValue()
    var
        SalesHeader: Record "Sales Header";
        ArchivedSalesNo: Code[20];
        LookupValueCode: Code[20];
        NewLookupValueCode: Code[20];
    begin
        //[SCENARIO #0013] Restore archived blanket order with lookup value to blanket order without lookup value.

        //[GIVEN] Lookup value
        LookupValueCode := CreateLookupValueCode();
        //[GIVEN] New lookup value
        NewLookupValueCode := '';
        //[GIVEN] Blanket order with lookup value.
        CreateDocumentWithLookupValue(SalesHeader, "Sales Document Type"::"Blanket Order", LookupValueCode);
        //[GIVEN] Archived blanket order with lookup value.
        CreateArchivedDocumentFromSalesDocument(SalesHeader."No.", "Sales Document Type"::"Blanket Order");
        //[GIVEN] Change Lookup value on blanket order to new lookup value (empty)
        ChangeLookupValueCodeForSalesDocument(SalesHeader."No.", NewLookupValueCode, "Sales Document Type"::"Blanket Order");

        //[WHEN] Restore archived blanket order.
        RestoreArchivedDocument(SalesHeader."No.", "Sales Document Type"::"Blanket Order");

        //[THEN] Blanket order has lookup value equals lookup value from the archived Blanket order.
        VerifySalesHeaderLookupValueEqualsArchivedLookupValue(SalesHeader."Lookup Value Code", LookupValueCode, "Sales Document Type"::"Blanket Order");
    end;

    [HandlerFunctions('ConfirmArchiveNo,ConfirmArchived')]
    [Test]
    procedure RestoreArchivedReturnOrderWithLookupValueToReturnOrderWithoutLookupValue()
    var
        SalesHeader: Record "Sales Header";
        ArchivedSalesNo: Code[20];
        LookupValueCode: Code[20];
        NewLookupValueCode: Code[20];
    begin
        //[SCENARIO #0014] Restore archived return order with lookup value to return order without lookup value.

        //[GIVEN] Lookup value
        LookupValueCode := CreateLookupValueCode();
        //[GIVEN] New lookup value
        NewLookupValueCode := '';
        //[GIVEN] return order with lookup value.
        CreateDocumentWithLookupValue(SalesHeader, "Sales Document Type"::"Return Order", LookupValueCode);
        //[GIVEN] Archived return order with lookup value.
        CreateArchivedDocumentFromSalesDocument(SalesHeader."No.", "Sales Document Type"::"Return Order");
        //[GIVEN] Change lookup value on return order to new lookup value (empty)
        ChangeLookupValueCodeForSalesDocument(SalesHeader."No.", NewLookupValueCode, "Sales Document Type"::"Return Order");

        //[WHEN] Restore archived return order.
        RestoreArchivedDocument(SalesHeader."No.", "Sales Document Type"::"Return Order");

        //[THEN] Return order has lookup value equals lookup value from the archived return order.
        VerifySalesHeaderLookupValueEqualsArchivedLookupValue(SalesHeader."Lookup Value Code", LookupValueCode, "Sales Document Type"::"Return Order");
    end;

    local procedure VerifySalesHeaderLookupValueEqualsArchivedLookupValue(ActualLookupValue: Code[20]; ExpectedLookupValue: Code[20]; DocumentType: Enum "Sales Document Type")
    var
        SalesHeader: Record "Sales Header";
    begin
        Assert.AreEqual(ExpectedLookupValue, ActualLookupValue, SalesHeader.FieldCaption("Lookup Value Code"));
    end;

    local procedure RestoreArchivedDocument(SalesHeaderNo: Code[20]; DocumentType: Enum "Sales Document Type")
    var
        ArchiveMgt: Codeunit ArchiveManagement;
        ArchivedDocument: Record "Sales Header Archive";
    begin
        ArchivedDocument.Get(DocumentType, SalesHeaderNo, 1, 1);
        ArchiveMgt.RestoreSalesDocument(ArchivedDocument);
    end;

    local procedure ChangeLookupValueCodeForSalesDocument(SalesHeaderNo: Code[20]; NewLookupValueCode: Code[20]; DocumentType: Enum "Sales Document Type")
    var
        SalesOrder: Record "Sales Header";
    begin
        SalesOrder.Get(DocumentType, SalesHeaderNo);
        SalesOrder."Lookup Value Code" := NewLookupValueCode;
        SalesOrder.Modify(true);
    end;

    local procedure CreateLookupValueCode(): Code[10]
    begin
        exit(LibraryLookupValue.CreateLookupValueCode())
    end;

    local procedure CreateArchivedDocumentFromSalesDocument(SalesOrderNo: Code[20]; DocumentType: Enum "Sales Document Type")
    var
        ArchiveMgt: Codeunit ArchiveManagement;
        SalesOrder: Record "Sales Header";
    begin
        SalesOrder.Get(DocumentType, SalesOrderNo);
        ArchiveMgt.ArchiveSalesDocument(SalesOrder);
    end;

    local procedure CreateDocumentWithoutLookupValue(var SalesHeader: Record "Sales Header"; DocumentType: Enum "Sales Document Type"): Code[20]
    begin
        LibrarySales.CreateSalesHeader(SalesHeader, DocumentType, '');

        exit(SalesHeader."No.");
    end;

    local procedure CreateDocumentWithLookupValue(var SalesHeader: Record "Sales Header"; DocumentType: Enum "Sales Document Type"; LookupValueCode: Code[20]): Code[20]
    begin
        LibrarySales.CreateSalesHeader(SalesHeader, DocumentType, '');

        SalesHeader.Validate("Lookup Value Code", LookupValueCode);
        SalesHeader.Modify();
        exit(SalesHeader."No.");
    end;

    local procedure RandomCode10(): Code[10];
    begin
        exit(Format(Random(999999999)));
    end;


    [ConfirmHandler]
    procedure ConfirmArchiveNo(Question: Text[1024]; var Reply: Boolean)
    begin
        Reply := true;
    end;

    [MessageHandler]
    procedure ConfirmArchived(Question: Text[1024])
    begin
    end;
}