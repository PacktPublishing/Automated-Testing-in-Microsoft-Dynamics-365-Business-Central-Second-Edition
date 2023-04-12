codeunit 81012 "LookupValue Copy Document"
{
    Subtype = Test;

    trigger OnRun()
    begin
        //[FEATURE] LookupValue UT Copy Document
    end;

    var
        Assert: Codeunit "Library Assert";
        LibrarySales: Codeunit "Library - Sales";
        LibraryLookupValue: Codeunit "Library - Lookup Value";

    [Test]
    procedure CopySalesOrderWithLookupValueToSalesOrderWithEmptyLookupValue()
    var
        SourceDocumentNo, TargetDocumentNo : Code[20];
    begin
        //[SCENARIO #0201] Copy sales order with lookup value to new sales order with empty lookup value

        //[GIVEN] Source sales order with lookup value
        SourceDocumentNo := CreateSalesDocumentWithLookupValue("Sales Document Type"::Order);
        //[GIVEN] Target sales order without lookup value
        TargetDocumentNo := CreateSalesDocumentWithEmptyLookupValue("Sales Document Type"::Order);

        //[WHEN] Copy sales document
        CopySalesDocument(SourceDocumentNo, TargetDocumentNo, "Sales Document Type"::Order, "Sales Document Type"::Order);

        //[THEN] Source document lookup value equals target document lookup value
        VerifySourceDocumentLookupValueEqualsTargetDocumentLookupValue(SourceDocumentNo, TargetDocumentNo, "Sales Document Type"::Order, "Sales Document Type"::Order);
    end;

    [Test]
    procedure CopySalesOrderWithLookupValueToSalesOrderWithNewLookupValue()
    var
        SourceDocumentNo, TargetDocumentNo : Code[20];
    begin
        //[SCENARIO #0202] Copy sales order with lookup value to sales order with new lookup value

        //[GIVEN] Source sales order with lookup value
        SourceDocumentNo := CreateSalesDocumentWithLookupValue("Sales Document Type"::Order);
        //[GIVEN] Target sales order with lookup value
        TargetDocumentNo := CreateSalesDocumentWithLookupValue("Sales Document Type"::Order);

        //[WHEN] Copy sales document
        CopySalesDocument(SourceDocumentNo, TargetDocumentNo, "Sales Document Type"::Order, "Sales Document Type"::Order);

        //[THEN] Source document lookup value equals target document lookup value
        VerifySourceDocumentLookupValueEqualsTargetDocumentLookupValue(SourceDocumentNo, TargetDocumentNo, "Sales Document Type"::Order, "Sales Document Type"::Order);
    end;

    [Test]
    procedure CopySalesOrderWithEmptyLookupValueToSalesOrderWithLookupValue()
    var
        SourceDocumentNo, TargetDocumentNo : Code[20];
    begin
        //[SCENARIO #0203] Copy sales order without lookup value to new sales order with lookup value

        //[GIVEN] Source sales order with empty lookup 
        SourceDocumentNo := CreateSalesDocumentWithEmptyLookupValue("Sales Document Type"::Order);
        //[GIVEN] Target sales order with lookup value
        TargetDocumentNo := CreateSalesDocumentWithLookupValue("Sales Document Type"::Order);

        //[WHEN] Copy sales document
        CopySalesDocument(SourceDocumentNo, TargetDocumentNo, "Sales Document Type"::Order, "Sales Document Type"::Order);

        //[THEN] Source document lookup value equals target document lookup value
        VerifySourceDocumentLookupValueEqualsTargetDocumentLookupValue(SourceDocumentNo, TargetDocumentNo, "Sales Document Type"::Order, "Sales Document Type"::Order);
    end;

    [Test]
    procedure CopySalesQuoteWithLookupValueToSalesQuoteWithEmptyLookupValue()
    var
        SourceDocumentNo, TargetDocumentNo : Code[20];
    begin
        //[SCENARIO #0204] Copy sales quote with lookup value to sales quote with empty lookup value

        //[GIVEN] Source sales quote with empty lookup value
        SourceDocumentNo := CreateSalesDocumentWithEmptyLookupValue("Sales Document Type"::Quote);
        //[GIVEN] Target sales quote with lookup value
        TargetDocumentNo := CreateSalesDocumentWithLookupValue("Sales Document Type"::Quote);

        //[WHEN] Copy sales document
        CopySalesDocument(SourceDocumentNo, TargetDocumentNo, "Sales Document Type"::Quote, "Sales Document Type"::Quote);

        //[THEN] Source document lookup value equals target document lookup value
        VerifySourceDocumentLookupValueEqualsTargetDocumentLookupValue(SourceDocumentNo, TargetDocumentNo, "Sales Document Type"::Quote, "Sales Document Type"::Quote);
    end;

    [Test]
    procedure CopySalesInvoiceWithLookupValueToSalesInvoiceWithEmptyLookupValue()
    var
        SourceDocumentNo, TargetDocumentNo : Code[20];
    begin
        //[SCENARIO #0205] Copy sales invoice with lookup value to sales invoice with empty lookup value

        //[GIVEN] Source sales invoice with empty lookup value
        SourceDocumentNo := CreateSalesDocumentWithEmptyLookupValue("Sales Document Type"::Invoice);
        //[GIVEN] Target sales invoice with lookup value
        TargetDocumentNo := CreateSalesDocumentWithLookupValue("Sales Document Type"::Invoice);

        //[WHEN] Copy sales document
        CopySalesDocument(SourceDocumentNo, TargetDocumentNo, "Sales Document Type"::Invoice, "Sales Document Type"::Invoice);

        //[THEN] Source document lookup value equals target document lookup value
        VerifySourceDocumentLookupValueEqualsTargetDocumentLookupValue(SourceDocumentNo, TargetDocumentNo, "Sales Document Type"::Invoice, "Sales Document Type"::Invoice);
    end;

    [Test]
    procedure CopyBlanketOrderWithLookupValueIntoBlanketOrderWithEmptyLookupValue()
    var
        SourceDocumentNo, TargetDocumentNo : Code[20];
    begin
        //[SCENARIO #0206] Copy blanket order with lookup value to blanket sales order with empty lookup value

        //[GIVEN] Source blanket order with empty lookup value
        SourceDocumentNo := CreateSalesDocumentWithEmptyLookupValue("Sales Document Type"::"Blanket Order");
        //[GIVEN] Target blanket order with lookup value
        TargetDocumentNo := CreateSalesDocumentWithLookupValue("Sales Document Type"::"Blanket Order");

        //[WHEN] Copy sales document
        CopySalesDocument(SourceDocumentNo, TargetDocumentNo, "Sales Document Type"::"Blanket Order", "Sales Document Type"::"Blanket Order");

        //[THEN] Source document lookup value equals target document lookup value
        VerifySourceDocumentLookupValueEqualsTargetDocumentLookupValue(SourceDocumentNo, TargetDocumentNo, "Sales Document Type"::"Blanket Order", "Sales Document Type"::"Blanket Order");
    end;

    [Test]
    procedure CopyReturnOrderWithLookupValueIntoReturnOrderWithEmptyLookupValue()
    var
        SourceDocumentNo, TargetDocumentNo : Code[20];
    begin
        //[SCENARIO #0207] Copy return order with lookup value to return order with empty lookup value

        //[GIVEN] Source return order with empty lookup value
        SourceDocumentNo := CreateSalesDocumentWithEmptyLookupValue("Sales Document Type"::"Return Order");
        //[GIVEN] Target return order with lookup value
        TargetDocumentNo := CreateSalesDocumentWithLookupValue("Sales Document Type"::"Return Order");

        //[WHEN] Copy sales document
        CopySalesDocument(SourceDocumentNo, TargetDocumentNo, "Sales Document Type"::"Return Order", "Sales Document Type"::"Return Order");

        //[THEN] Source document lookup value equals target document lookup value
        VerifySourceDocumentLookupValueEqualsTargetDocumentLookupValue(SourceDocumentNo, TargetDocumentNo, "Sales Document Type"::"Return Order", "Sales Document Type"::"Return Order");
    end;

    local procedure CreateSalesDocumentWithLookupValue(DocumentType: Enum "Sales Document Type"): Code[20]
    var
        SalesHeader: Record "Sales Header";
    begin
        LibrarySales.CreateSalesHeader(SalesHeader, DocumentType, '');

        SalesHeader.Validate("Lookup Value Code", CreateLookupValueCode());
        SalesHeader.Modify();
        exit(SalesHeader."No.")
    end;

    local procedure CreateSalesDocumentWithEmptyLookupValue(DocumentType: Enum "Sales Document Type"): Code[20]
    var
        SalesHeader: Record "Sales Header";
    begin
        LibrarySales.CreateSalesHeader(SalesHeader, DocumentType, '');
        exit(SalesHeader."No.");
    end;

    local procedure CopySalesDocument(SourceDocumentNo: Code[20]; TargetDocumentNo: Code[20]; FromDocumentType: Enum "Sales Document Type"; ToDocumentType: Enum "Sales Document Type")
    var
        FromSalesHeader, ToSalesHeader : Record "Sales Header";
        CopyDocumentMgt: Codeunit "Copy Document Mgt.";
    begin
        FromSalesHeader.Get(FromDocumentType, SourceDocumentNo);
        ToSalesHeader.Get(ToDocumentType, TargetDocumentNo);
        CopyDocumentMgt.SetProperties(true, false, false, false, true, false, true);
        CopyDocumentMgt.CopySalesDoc(ConvertToSalesDocumentTypeFrom(FromDocumentType), SourceDocumentNo, ToSalesHeader);
    end;

    local procedure ConvertToSalesDocumentTypeFrom(SalesDocType: Enum "Sales Document Type") SalesDocTypeFrom: Enum "Sales Document Type From"
    begin
        case SalesDocType of
            SalesDocType::Quote:
                exit(SalesDocTypeFrom::Quote);
            SalesDocType::Order:
                exit(SalesDocTypeFrom::Order);
            SalesDocType::Invoice:
                exit(SalesDocTypeFrom::Invoice);
            SalesDocType::"Credit Memo":
                exit(SalesDocTypeFrom::"Credit Memo");
            SalesDocType::"Blanket Order":
                exit(SalesDocTypeFrom::"Blanket Order");
            SalesDocType::"Return Order":
                exit(SalesDocTypeFrom::"Return Order");
        end;
    end;

    local procedure CreateLookupValueCode(): Code[10]
    begin
        exit(LibraryLookupValue.CreateLookupValueCode())
    end;

    local procedure VerifySourceDocumentLookupValueEqualsTargetDocumentLookupValue(SourceDocumentNo: Code[20]; TargetDocumentNo: Code[20]; FromDocumentType: Enum "Sales Document Type"; ToDocumentType: Enum "Sales Document Type")
    var
        FromSalesHeader, ToSalesHeader : Record "Sales Header";
    begin
        FromSalesHeader.Get(FromDocumentType, SourceDocumentNo);
        ToSalesHeader.Get(ToDocumentType, TargetDocumentNo);
        Assert.AreEqual(FromSalesHeader."Lookup Value Code", ToSalesHeader."Lookup Value Code", ToSalesHeader.FieldCaption("Lookup Value Code"));
    end;
}