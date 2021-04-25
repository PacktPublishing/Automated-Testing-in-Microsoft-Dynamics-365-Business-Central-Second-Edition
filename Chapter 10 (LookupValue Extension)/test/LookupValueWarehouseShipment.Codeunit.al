codeunit 81003 "LookupValue Warehouse Shipment"
{
    Subtype = Test;

    trigger OnRun()
    begin
        //[FEATURE] LookupValue Warehouse Shipment
    end;

    var
        DefaultLocation: Record Location;
        Assert: Codeunit "Library Assert";
        LibrarySales: Codeunit "Library - Sales";
        LibraryWarehouse: Codeunit "Library - Warehouse";
        LibraryLookupValue: Codeunit "Library - Lookup Value";
        LibraryMessages: Codeunit "Library - Messages";
        isInitialized: Boolean;
        LookupValueCode: Code[10];

    // Instruction NOTES
    // (1) Replacing the argument LookupValueCode in verification call, i.e. [THEN] clause, should make any test fail
    // (2) Making field "Lookup Value Code", on any of the related pages, Visible=false should make any UI test fail

    [Test]
    procedure AssignLookupValueToWarehouseShipmentLine()
    //[FEATURE] LookupValue Warehouse Shipment
    var
        SalesOrderNo: Code[20];
    begin
        //[SCENARIO #0015] Assign lookup value to warehouse shipment line on warehouse shipment page

        //[GIVEN] Lookup value
        //[GIVEN] Location with require shipment
        //[GIVEN] Warehouse employee for current user
        Initialize();
        //[GIVEN] Warehouse shipment from released sales order with line with require shipment location
        SalesOrderNo := CreateWarehouseShipmentFromSalesOrder(DefaultLocation, UseNoLookupValue());

        //[WHEN] Set lookup value on warehouse shipment line on warehouse shipment page
        FindAndSetLookupValueOnWarehouseShipmentLine(SalesOrderNo, LookupValueCode);

        //[THEN] Warehouse shipment line has lookup value code field populated
        VerifyLookupValueOnWarehouseShipmentLine(SalesOrderNo, LookupValueCode);
    end;

    [Test]
    procedure AssignNonExistingLookupValueToWarehouseShipmentHeader()
    //[FEATURE] LookupValue UT Warehouse Shipment
    var
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
        NoExistingLookupValueCode: Code[10];
    begin
        //[SCENARIO #0016] Assign non-existing lookup value on warehouse shipment line

        //[GIVEN] Non-existing lookup value
        NoExistingLookupValueCode := 'SC #0016';
        //[GIVEN] Warehouse shipment line record variable
        // See local variable WarehouseShipmentLine

        //[WHEN] Set non-existing lookup value to warehouse shipment line
        asserterror SetLookupValueOnWarehouseShipmentLine(WarehouseShipmentLine, NoExistingLookupValueCode);

        //[THEN] Non existing lookup value error was thrown
        VerifyNonExistingLookupValueError(NoExistingLookupValueCode);
    end;

    [Test]
    procedure AssignLookupValueToLineOnWarehouseShipmentDocument()
    //[FEATURE] LookupValue Warehouse Shipment
    var
        SalesOrderNo: Code[20];
    begin
        //[SCENARIO #0017] Assign lookup value to warehouse shipment line on warehouse shipment page

        //[GIVEN] Lookup value
        //[GIVEN] Location with require shipment
        //[GIVEN] Warehouse employee for current user
        Initialize();
        //[GIVEN] Warehouse shipment from released sales order with line with require shipment location
        SalesOrderNo := CreateWarehouseShipmentFromSalesOrder(DefaultLocation, UseNoLookupValue());

        //[WHEN] Set lookup value on warehouse shipment line on warehouse shipment document page
        SetLookupValueOnLineOnWarehouseShipmentDocumentPage(SalesOrderNo);

        //[THEN] Warehouse shipment line has lookup value code field populated
        VerifyLookupValueOnWarehouseShipmentLine(SalesOrderNo, LookupValueCode);
    end;

    [Test]
    procedure CreateWarehouseShipmentFromSalesOrderWithLookupValue()
    //[FEATURE] LookupValue Warehouse Shipment
    var
        SalesOrderNo: Code[20];
    begin
        //[SCENARIO #0030] Create warehouse shipment from sales order with lookup value
        //[GIVEN] Lookup value
        //[GIVEN] Location with require shipment
        //[GIVEN] Warehouse employee for current user
        Initialize();

        //[WHEN] Create warehouse shipment from released sales order with lookup value and with line with require shipment location
        SalesOrderNo := CreateWarehouseShipmentFromSalesOrder(DefaultLocation, UseLookupValue());

        //[THEN] Warehouse shipment line has lookup value code field populated
        VerifyLookupValueOnWarehouseShipmentLine(SalesOrderNo, LookupValueCode);
    end;

    [Test]
    procedure GetSalesOrderWithLookupValueOnWarehouseShipment()
    //[FEATURE] LookupValue Warehouse Shipment
    var
        SalesHeader: Record "Sales Header";
        WarehouseShipmentNo: Code[20];
    begin
        //[SCENARIO #0031] Get sales order with lookup value on warehouse shipment

        //[GIVEN] Lookup value
        //[GIVEN] Location with require shipment
        //[GIVEN] Warehouse employee for current user
        Initialize();
        //[GIVEN] Released sales order with lookup value and with line with require shipment location
        CreateAndReleaseSalesOrder(SalesHeader, DefaultLocation, UseLookupValue());
        //[GIVEN] Warehouse shipment without lines
        WarehouseShipmentNo := CreateWarehouseShipmentWithOutLines(DefaultLocation."Code");

        //[WHEN] Get sales order with lookup value on warehouse shipment
        GetSalesOrderShipment(WarehouseShipmentNo);

        //[THEN] Warehouse shipment line has lookup value code field populated
        VerifyLookupValueOnWarehouseShipmentLine(SalesHeader."No.", LookupValueCode);
    end;

    local procedure UseLookupValue(): Boolean
    begin
        exit(true)
    end;

    local procedure UseNoLookupValue(): Boolean
    begin
        exit(false)
    end;

    local procedure Initialize()
    var
        WarehouseEmployee: Record "Warehouse Employee";
        LibraryTestsSetup: Codeunit "Library - Tests Setup";
    begin
        if isInitialized then
            exit;

        //[GIVEN] technical: SetSkipOnAfterCreateCustomer (see chapter 9) 
        LibraryTestsSetup.SetSkipOnAfterCreateCustomer(true);
        //[GIVEN] Lookup value
        LookupValueCode := LibraryLookupValue.CreateLookupValueCode();
        //[GIVEN] Location with require shipment
        LibraryWarehouse.CreateLocationWMS(DefaultLocation, false, false, false, false, true);
        //[GIVEN] Warehouse employee for current user
        LibraryWarehouse.CreateWarehouseEmployee(WarehouseEmployee, DefaultLocation."Code", false);

        isInitialized := true;
        Commit();
    end;

    local procedure CreateWarehouseShipmentFromSalesOrder(Location: Record Location; WithLookupValue: Boolean): Code[20]
    var
        SalesHeader: Record "Sales Header";
    begin
        CreateAndReleaseSalesOrder(SalesHeader, Location, WithLookupValue);
        LibraryWarehouse.CreateWhseShipmentFromSO(SalesHeader);
        exit(SalesHeader."No.");
    end;

    local procedure CreateAndReleaseSalesOrder(var SalesHeader: record "Sales Header"; Location: Record Location; WithLookupValue: Boolean)
    var
        SalesLine: record "Sales Line";
    begin
        LibrarySales.CreateSalesDocumentWithItem(SalesHeader, SalesLine, SalesHeader."Document Type"::Order, '', '', 1, Location."Code", 0D);

        if WithLookupValue then begin
            SalesHeader.Validate("Lookup Value Code", LookupValueCode);
            SalesHeader.Modify();
        end;

        LibrarySales.ReleaseSalesDocument(SalesHeader);
    end;

    local procedure FindWarehouseShipmentLine(var WarehouseShipmentLine: Record "Warehouse Shipment Line"; SourceNo: Code[20])
    begin
        WarehouseShipmentLine.SetRange("Source Document", WarehouseShipmentLine."Source Document"::"Sales Order");
        WarehouseShipmentLine.SetRange("Source No.", SourceNo);
        WarehouseShipmentLine.FindFirst();
    end;

    local procedure FindAndSetLookupValueOnWarehouseShipmentLine(DocumentNo: Code[20]; LookupValueCode: Code[10])
    var
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
    begin
        FindWarehouseShipmentLine(WarehouseShipmentLine, DocumentNo);
        SetLookupValueOnWarehouseShipmentLine(WarehouseShipmentLine, LookupValueCode);
    end;

    local procedure SetLookupValueOnWarehouseShipmentLine(var WarehouseShipmentLine: Record "Warehouse Shipment Line"; LookupValueCode: Code[10])
    begin
        WarehouseShipmentLine.Validate("Lookup Value Code", LookupValueCode);
        WarehouseShipmentLine.Modify();
    end;

    local procedure SetLookupValueOnLineOnWarehouseShipmentDocumentPage(DocumentNo: Code[20])
    var
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
        WarehouseShipmentPage: TestPage "Warehouse Shipment";
    begin
        FindWarehouseShipmentLine(WarehouseShipmentLine, DocumentNo);
        WarehouseShipmentPage.OpenEdit();
        WarehouseShipmentPage.GoToKey(WarehouseShipmentLine."No.");
        WarehouseShipmentPage.WhseShptLines.GoToKey(WarehouseShipmentLine."No.", WarehouseShipmentLine."Line No.");
        Assert.IsTrue(WarehouseShipmentPage.WhseShptLines."Lookup Value Code".Editable(), 'Editable');
        WarehouseShipmentPage.WhseShptLines."Lookup Value Code".SetValue(LookupValueCode);
        WarehouseShipmentPage.Close();
    end;

    local procedure CreateWarehouseShipmentWithOutLines(LocationCode: Code[10]): Code[20]
    var
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
    begin
        LibraryWarehouse.CreateWarehouseShipmentHeader(WarehouseShipmentHeader);
        WarehouseShipmentHeader.Validate("Location Code", LocationCode);
        WarehouseShipmentHeader.Modify();
        exit(WarehouseShipmentHeader."No.");
    end;

    local procedure GetSalesOrderShipment(WarehouseShipmentNo: Code[20])
    var
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
        WarehouseSourceFilter: Record "Warehouse Source Filter";
    begin
        WarehouseShipmentHeader.Get(WarehouseShipmentNo);
        LibraryWarehouse.GetSourceDocumentsShipment(WarehouseShipmentHeader, WarehouseSourceFilter, WarehouseShipmentHeader."Location Code");
    end;

    local procedure VerifyLookupValueOnWarehouseShipmentLine(DocumentNo: Code[20]; LookupValueCode: Code[10])
    var
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
    begin
        FindWarehouseShipmentLine(WarehouseShipmentLine, DocumentNo);
        Assert.AreEqual(
            LookupValueCode,
            WarehouseShipmentLine."Lookup Value Code",
            LibraryMessages.GetFieldOnTableTxt(
                WarehouseShipmentLine.FieldCaption("Lookup Value Code"),
                WarehouseShipmentLine.TableCaption()));
    end;

    local procedure VerifyNonExistingLookupValueError(LookupValueCode: Code[10])
    var
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
        LookupValue: Record LookupValue;
    begin
        Assert.ExpectedError(
            LibraryMessages.GetValueCannotBeFoundInTableTxt(
                WarehouseShipmentLine.FieldCaption("Lookup Value Code"),
                WarehouseShipmentLine.TableCaption(),
                LookupValueCode,
                LookupValue.TableCaption()));
    end;
}
