codeunit 81013 "LookupValue Sales Archive 2"
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
        LibraryVariableStorage: Codeunit "Library - Variable Storage";

    [HandlerFunctions('ConfirmHandlerYes,MessageHandler')]
    [Test]
    procedure RestoreArchivedSalesOrderWithLookupValueToSalesOrderWithLookupValue()
    var
        SalesOrder: Record "Sales Header";
        LookupValueCode: Code[20];
        NewLookupValueCode: Code[20];
    begin
        //[SCENARIO #0100] Restore archived sales order with lookup value to sales order with changed lookup value.

        //[GIVEN] Sales order with lookup value
        LookupValueCode := CreateSalesDocumentWithLookupValue(SalesOrder, "Sales Document Type"::Order);
        //[GIVEN] Sales order is archived
        ArchiveSalesDocument(SalesOrder);
        //[GIVEN] New lookup value
        NewLookupValueCode := CreateLookupValueCode();
        //[GIVEN] Lookup value on sales order changed to new lookup value
        ChangeLookupValueOnSalesDocument(SalesOrder."No.", NewLookupValueCode, "Sales Document Type"::Order);

        //[WHEN] Restore archived sales order
        RestoreArchivedDocument(SalesOrder."No.", "Sales Document Type"::Order);

        //[THEN] Sales order lookup value equals lookup value of archived sales order
        VerifySalesDocumentLookupValueEqualsLookupValueOfArchivedSalesDocument(SalesOrder."Lookup Value Code", LookupValueCode);
    end;

    [HandlerFunctions('ConfirmHandlerYes,MessageHandler')]
    [Test]
    procedure RestoreArchivedSalesOrderWithEmptyLookupValueToSalesOrderWithLookupValue()
    var
        SalesOrder: Record "Sales Header";
        NewLookupValueCode: Code[20];
    begin
        //[SCENARIO #0101] Restore archived sales order with empty lookup value to sales order with lookup value.

        //[GIVEN] Sales order with empty lookup value
        CreateDocumentWithEmptyLookupValue(SalesOrder, "Sales Document Type"::Order);
        //[GIVEN] Sales order is archived
        ArchiveSalesDocument(SalesOrder);
        //[GIVEN] New lookup value
        NewLookupValueCode := CreateLookupValueCode();
        //[GIVEN] Lookup value on sales order changed to new lookup value
        ChangeLookupValueOnSalesDocument(SalesOrder."No.", NewLookupValueCode, "Sales Document Type"::Order);

        //[WHEN] Restore archived sales order
        RestoreArchivedDocument(SalesOrder."No.", "Sales Document Type"::Order);

        //[THEN] Sales order lookup value is empty
        VerifySalesDocumentLookupValueIsEmpty(SalesOrder."Lookup Value Code");
    end;

    [HandlerFunctions('ConfirmHandlerYes,MessageHandler')]
    [Test]
    procedure RestoreArchivedSalesOrderWithLookupValueToSalesOrderWithEmptyLookupValue()
    begin
        //[SCENARIO #0102] Restore archived sales order with lookup value to sales order with empty lookup value
        RestoreArchivedSalesDocumentWithLookupValueToSalesDocumentWithEmptyLookupValue("Sales Document Type"::Order);
    end;

    [HandlerFunctions('ConfirmHandlerYes,MessageHandler')]
    [Test]
    procedure RestoreArchivedSalesQuoteWithLookupValueToSalesQuoteWithEmptyLookupValue()
    begin
        //[SCENARIO #0103] Restore archived sales quote with lookup value to sales quote with empty lookup value
        RestoreArchivedSalesDocumentWithLookupValueToSalesDocumentWithEmptyLookupValue("Sales Document Type"::Quote);
    end;

    [HandlerFunctions('ConfirmHandlerYes,MessageHandler')]
    [Test]
    procedure RestoreArchivedSalesInvoiceWithLookupValueToSalesInvoiceWithEmptyLookupValue()
    begin
        //[SCENARIO #0104] Restore archived sales invoice with lookup value to sales invoice with empty lookup value
        RestoreArchivedSalesDocumentWithLookupValueToSalesDocumentWithEmptyLookupValue("Sales Document Type"::Invoice);
    end;

    [HandlerFunctions('ConfirmHandlerYes,MessageHandler')]
    [Test]
    procedure RestoreArchivedBlanketOrderWithLookupValueToBlanketOrderWithEmptyLookupValue()
    var
        BlanketOrder: Record "Sales Header";
        LookupValueCode: Code[20];
    begin
        //[SCENARIO #0105] Restore archived blanket order with lookup value to blanket order with empty lookup value
        RestoreArchivedSalesDocumentWithLookupValueToSalesDocumentWithEmptyLookupValue("Sales Document Type"::"Blanket Order");
    end;

    [HandlerFunctions('ConfirmHandlerYes,MessageHandler')]
    [Test]
    procedure RestoreArchivedReturnOrderWithLookupValueToReturnOrderWithEmptyLookupValue()
    begin
        //[SCENARIO #0106] Restore archived return order with lookup value to return order with empty lookup value
        RestoreArchivedSalesDocumentWithLookupValueToSalesDocumentWithEmptyLookupValue("Sales Document Type"::"Return Order");
    end;

    [HandlerFunctions('ConfirmHandlerYes,MessageHandler')]
    [Test]
    procedure RestoreArchivedCreditMemoWithLookupValueToCreditMemoWithEmptyLookupValue()
    begin
        //[SCENARIO #0107] Restore archived credit memo with lookup value to credit memo with empty lookup value
        RestoreArchivedSalesDocumentWithLookupValueToSalesDocumentWithEmptyLookupValue("Sales Document Type"::"Credit Memo");
    end;

    local procedure RestoreArchivedSalesDocumentWithLookupValueToSalesDocumentWithEmptyLookupValue(DocumentType: Enum "Sales Document Type"): Code[20]
    var
        SalesHeader: Record "Sales Header";
        LookupValueCode: Code[20];
    begin
        //[GIVEN] Sales document with lookup value
        LookupValueCode := CreateSalesDocumentWithLookupValue(SalesHeader, DocumentType);
        //[GIVEN] Sales document is archived
        ArchiveSalesDocument(SalesHeader);
        //[GIVEN] Lookup value on sales document is emptied
        EmptyLookupValueOnSalesDocument(SalesHeader."No.", DocumentType);

        //[WHEN] Restore archived sales document
        RestoreArchivedDocument(SalesHeader."No.", DocumentType);

        //[THEN] Sales document lookup value equals archived sales order lookup value
        VerifySalesDocumentLookupValueEqualsLookupValueOfArchivedSalesDocument(SalesHeader."Lookup Value Code", LookupValueCode);

        exit(SalesHeader."No.")
    end;

    local procedure CreateLookupValueCode(): Code[10]
    begin
        exit(LibraryLookupValue.CreateLookupValueCode())
    end;

    local procedure CreateSalesDocumentWithLookupValue(var SalesHeader: Record "Sales Header"; DocumentType: Enum "Sales Document Type"): Code[20]
    begin
        CreateDocumentWithEmptyLookupValue(SalesHeader, DocumentType);

        SalesHeader.Validate("Lookup Value Code", CreateLookupValueCode());
        SalesHeader.Modify();
        exit(SalesHeader."Lookup Value Code")
    end;

    local procedure CreateDocumentWithEmptyLookupValue(var SalesHeader: Record "Sales Header"; DocumentType: Enum "Sales Document Type"): Code[20]
    begin
        LibrarySales.CreateSalesHeader(SalesHeader, DocumentType, '');
        exit(SalesHeader."No.");
    end;

    local procedure ArchiveSalesDocument(SalesHeader: Record "Sales Header")
    var
        ArchiveManagement: Codeunit ArchiveManagement;
    begin
        LibraryVariableStorage.Enqueue(1);
        LibraryVariableStorage.Enqueue(SalesHeader."Document Type");
        LibraryVariableStorage.Enqueue(SalesHeader."No.");

        LibraryVariableStorage.Enqueue(1);
        LibraryVariableStorage.Enqueue(SalesHeader."No.");

        ArchiveManagement.ArchiveSalesDocument(SalesHeader);
    end;

    local procedure ChangeLookupValueOnSalesDocument(SalesHeaderNo: Code[20]; NewLookupValueCode: Code[20]; DocumentType: Enum "Sales Document Type")
    var
        SalesOrder: Record "Sales Header";
    begin
        SalesOrder.Get(DocumentType, SalesHeaderNo);
        SalesOrder."Lookup Value Code" := NewLookupValueCode;
        SalesOrder.Modify(true);
    end;

    local procedure EmptyLookupValueOnSalesDocument(SalesHeaderNo: Code[20]; DocumentType: Enum "Sales Document Type")
    begin
        ChangeLookupValueOnSalesDocument(SalesHeaderNo, '', DocumentType)
    end;

    local procedure RestoreArchivedDocument(SalesHeaderNo: Code[20]; DocumentType: Enum "Sales Document Type")
    var
        ArchiveMgt: Codeunit ArchiveManagement;
        ArchivedDocument: Record "Sales Header Archive";
    begin
        ArchivedDocument.Get(DocumentType, SalesHeaderNo, 1, 1);

        LibraryVariableStorage.Enqueue(2);
        LibraryVariableStorage.Enqueue(DocumentType);
        LibraryVariableStorage.Enqueue(SalesHeaderNo);
        LibraryVariableStorage.Enqueue(1);

        LibraryVariableStorage.Enqueue(2);
        LibraryVariableStorage.Enqueue(DocumentType);
        LibraryVariableStorage.Enqueue(SalesHeaderNo);

        ArchiveMgt.RestoreSalesDocument(ArchivedDocument);
    end;

    local procedure VerifySalesDocumentLookupValueEqualsLookupValueOfArchivedSalesDocument(ActualLookupValue: Code[20]; ExpectedLookupValue: Code[20])
    var
        SalesHeader: Record "Sales Header";
    begin
        Assert.AreEqual(ExpectedLookupValue, ActualLookupValue, SalesHeader.FieldCaption("Lookup Value Code"));
    end;

    local procedure VerifySalesDocumentLookupValueIsEmpty(ActualLookupValue: Code[20])
    var
        SalesHeader: Record "Sales Header";
    begin
        Assert.AreEqual('', ActualLookupValue, SalesHeader.FieldCaption("Lookup Value Code"));
    end;

    [ConfirmHandler]
    procedure ConfirmHandlerYes(Question: Text[1024]; var Reply: Boolean);
    var
        SequenceNo: Integer;
        ArchiveDocumentQst: Label 'Archive %1 no.: %2';
        RestoreDocumentQst: Label 'Do you want to Restore %1 %2 Version %3?';
    begin
        SequenceNo := LibraryVariableStorage.DequeueInteger();
        case SequenceNo of
            1: // Archive
                Assert.ExpectedMessage(
                    StrSubstNo(ArchiveDocumentQst,
                        LibraryVariableStorage.DequeueText(),
                        LibraryVariableStorage.DequeueText()
                    ),
                    Question);
            2: // Restore
                Assert.ExpectedMessage(
                    StrSubstNo(RestoreDocumentQst,
                        LibraryVariableStorage.DequeueText(),
                        LibraryVariableStorage.DequeueText(),
                        LibraryVariableStorage.DequeueInteger()
                    ),
                    Question);
        end;
        Reply := true;
    end;

    [MessageHandler]
    procedure MessageHandler(Message: Text[1024])
    var
        SequenceNo: Integer;
        DocumentHasBeenArchivedTxt: Label 'Document %1 has been archived';
        DocumentHasBeenRestoredTxt: Label '%1 %2 has been restored';
    begin
        SequenceNo := LibraryVariableStorage.DequeueInteger();
        case SequenceNo of
            1: // Archived
                Assert.ExpectedMessage(
                    StrSubstNo(DocumentHasBeenArchivedTxt,
                        LibraryVariableStorage.DequeueText()),
                    Message);
            2: // Restored
                Assert.ExpectedMessage(
                    StrSubstNo(DocumentHasBeenRestoredTxt,
                        LibraryVariableStorage.DequeueText(),
                        LibraryVariableStorage.DequeueText()),
                    Message);
        end;
    end;
}