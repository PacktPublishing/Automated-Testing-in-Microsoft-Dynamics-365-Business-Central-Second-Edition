codeunit 81004 "LookupValue Sales Archive"
{
    Subtype = Test;

    trigger OnRun()
    begin
        //[FEATURE] LookupValue Sales Archive
    end;

    var
        Assert: Codeunit "Library Assert";
        LibrarySales: Codeunit "Library - Sales";
        LibraryLookupValue: Codeunit "Library - Lookup Value";
        LibraryMessages: Codeunit "Library - Messages";

    // Instruction NOTES
    // (1) Replacing the argument LookupValueCode in verification call, i.e. [THEN] clause, should make any test fail

    [Test]
    [HandlerFunctions('ConfirmHandlerYes,MessageHandler')]
    procedure ArchiveSalesOrderWithLookupValue();
    //[FEATURE] LookupValue Sales Archive
    var
        SalesHeader: record "Sales Header";
    begin
        //[SCENARIO #0018] Archive sales order with lookup value
        ArchiveSalesDocumentWithLookupValue(SalesHeader."Document Type"::Order)
    end;

    [Test]
    [HandlerFunctions('ConfirmHandlerYes,MessageHandler')]
    procedure ArchiveSalesQuoteWithLookupValue();
    //[FEATURE] LookupValue Sales Archive
    var
        SalesHeader: record "Sales Header";
    begin
        //[SCENARIO #0019] Archive sales quote with lookup value
        ArchiveSalesDocumentWithLookupValue(SalesHeader."Document Type"::Quote)
    end;

    [Test]
    [HandlerFunctions('ConfirmHandlerYes,MessageHandler')]
    procedure ArchiveSalesReturnOrderWithLookupValue();
    //[FEATURE] LookupValue Sales Archive
    var
        SalesHeader: record "Sales Header";
    begin
        //[SCENARIO #0020] Archive sales return order with lookup value
        ArchiveSalesDocumentWithLookupValue(SalesHeader."Document Type"::"Return Order")
    end;

    [Test]
    [HandlerFunctions('ConfirmHandlerYes,MessageHandler')]
    procedure FindLookupValueOnSalesListArchive();
    //[FEATURE] LookupValue Sales Archive
    var
        SalesHeader: record "Sales Header";
        DocumentNo: Code[20];
    begin
        //[SCENARIO #0021] Check that lookup value is shown right on Sales List Archive
        //[GIVEN] Sales document with lookup value
        //[WHEN] Sales document is archived
        //[THEN] Archived sales document has lookup value from sales document
        DocumentNo := ArchiveSalesDocumentWithLookupValue(SalesHeader."Document Type"::Order);
        //[THEN] LookupValue is shown right on Sales List Archive
        VerifyLookupValueOnSalesListArchive(SalesHeader."Document Type"::Order, DocumentNo);
    end;

    local procedure ArchiveSalesDocumentWithLookupValue(DocumentType: Enum "Sales Document Type"): Code[20]
    var
        SalesHeader: record "Sales Header";
        LibraryTestsSetup: Codeunit "Library - Tests Setup";
    begin
        //[GIVEN] technical: SetSkipOnAfterCreateCustomer (see chapter 9) 
        LibraryTestsSetup.SetSkipOnAfterCreateCustomer(true);

        //[GIVEN] Sales document with lookup value
        CreateSalesDocumentWithLookupValue(SalesHeader, DocumentType);

        //[WHEN] Sales document is archived
        ArchiveSalesDocument(SalesHeader);

        //[THEN] Archived sales document has lookup value from sales document
        VerifyLookupValueOnSalesDocumentArchive(DocumentType, SalesHeader."No.", SalesHeader."Lookup Value Code", 1);  // Used 1 for No. of Archived Versions

        exit(SalesHeader."No.")
    end;

    local procedure CreateSalesDocumentWithLookupValue(var SalesHeader: record "Sales Header"; DocumentType: Enum "Sales Document Type"): Code[20]
    begin
        LibrarySales.CreateSalesHeader(SalesHeader, DocumentType, '');

        SalesHeader.Validate("Lookup Value Code", CreateLookupValueCode());
        SalesHeader.Modify();
        exit(SalesHeader."Lookup Value Code")
    end;

    local procedure CreateLookupValueCode(): Code[10]
    begin
        exit(LibraryLookupValue.CreateLookupValueCode())
    end;

    local procedure ArchiveSalesDocument(var SalesHeader: Record "Sales Header");
    var
        ArchiveManagement: Codeunit ArchiveManagement;
    begin
        ArchiveManagement.ArchiveSalesDocument(SalesHeader);
    end;

    local procedure VerifyLookupValueOnSalesDocumentArchive(DocumentType: Enum "Sales Document Type"; DocumentNo: Code[20]; LookupValueCode: Code[20]; VersionNo: Integer);
    var
        SalesHeaderArchive: Record "Sales Header Archive";
    begin
        FindSalesDocumentArchive(SalesHeaderArchive, DocumentType, DocumentNo);
        SalesHeaderArchive.SetRange("Version No.", VersionNo);
        SalesHeaderArchive.FindFirst();
        Assert.AreEqual(LookupValueCode, SalesHeaderArchive."Lookup Value Code", '');
    end;

    local procedure VerifyLookupValueOnSalesListArchive(DocumentType: Enum "Sales Document Type"; DocumentNo: Code[20])
    var
        SalesHeaderArchive: Record "Sales Header Archive";
        SalesListArchive: TestPage "Sales List Archive";
    begin
        SalesHeaderArchive.Get(DocumentType, DocumentNo, 1, 1);  // Used 1 for Occurrence of Document No.  No. of Archived Versions
        SalesListArchive.OpenView();
        SalesListArchive.GoToRecord(SalesHeaderArchive);

        Assert.AreEqual(SalesHeaderArchive."Lookup Value Code", SalesListArchive."Lookup Value Code".Value(), LibraryMessages.GetFieldOnTableTxt(SalesHeaderArchive.FieldCaption("Lookup Value Code"), SalesHeaderArchive.TableCaption()));
    end;

    local procedure FindSalesDocumentArchive(var SalesHeaderArchive: Record "Sales Header Archive"; DocumentType: Enum "Sales Document Type"; DocumentNo: Code[20])
    begin
        SalesHeaderArchive.SetRange("Document Type", DocumentType);
        SalesHeaderArchive.SetRange("No.", DocumentNo);
        SalesHeaderArchive.FindFirst();
    end;

    [ConfirmHandler]
    procedure ConfirmHandlerYes(Question: Text[1024]; var Reply: Boolean);
    begin
        // Just to handle the confirm
        Reply := true;
    end;

    [MessageHandler]
    procedure MessageHandler(Message: Text[1024]);
    begin
        // Just to handle the message
    end;
}