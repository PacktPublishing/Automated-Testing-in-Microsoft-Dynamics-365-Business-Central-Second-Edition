codeunit 81020 "LookupValue Permissions"
{
    Subtype = Test;

    var
        LibraryLookupValue: Codeunit "Library - Lookup Value";

    trigger OnRun()
    begin
        //[FEATURE] LookupValue Permissions
    end;

    var
        Assert: Codeunit "Library Assert";
        LibraryUtility: Codeunit "Library - Utility";
        LibraryLowerPermissions: Codeunit "Library - Lower Permissions";

    [Test]
    procedure CreateLookupValueWithoutPermissions()
    begin
        //[SCENARIO #0041] Create lookup value without permissions

        //[GIVEN] Full base starting permissions
        SetFullBaseStartingPermissions();

        //[WHEN] Create lookup value
        asserterror CreateLookupValueCode();

        //[THEN] Insert permissions error thrown
        VerifyPermissionsErrorThrown('Insert');
    end;

    [Test]
    procedure CreateLookupValueWithPermissions()
    var
        LookupValueCode: Code[10];
    begin
        //[SCENARIO #0042] Create lookup value with permissions

        //[GIVEN] Full base starting permissions extended with Lookup Value permissions
        SetFullBaseStartingPermissionsExtendedWithLookupValue();

        //[WHEN] Create lookup value
        LookupValueCode := CreateLookupValueCode();

        //[THEN] Lookup value exists
        VerifyLookupValueExists(LookupValueCode);
    end;

    [Test]
    procedure ReadLookupValueWithoutPermissions()
    var
        LookupValueCode: Code[10];
    begin
        //[SCENARIO #0043] Read lookup value without permissions

        //[GIVEN] Unrestricted starting permissions
        SetUnrestrictedStartingPermissions();
        //[GIVEN] Create lookup value
        LookupValueCode := CreateLookupValueCode();
        //[GIVEN] Full base permissions
        SetFullBasePermissions();

        //[WHEN] Read lookup value
        asserterror ReadLookupValueCode(LookupValueCode);

        //[THEN] Read permissions error thrown
        VerifyPermissionsErrorThrown('Read');
    end;

    [Test]
    procedure ReadLookupValueWithPermissions()
    var
        LookupValueCode: Code[10];
    begin
        //[SCENARIO #0044] Read lookup value with permissions

        //[GIVEN] Unrestricted starting permissions
        SetUnrestrictedStartingPermissions();
        //[GIVEN] Create lookup value
        LookupValueCode := CreateLookupValueCode();
        //[GIVEN] Full base permissions extended with Lookup Value
        SetFullBasePermissionsExtendedWithLookupValue();

        //[WHEN] Read lookup value
        ReadLookupValueCode(LookupValueCode);

        //[THEN] Lookup value exists
        VerifyLookupValueExists(LookupValueCode);
    end;

    [Test]
    procedure ModifyLookupValueWithoutPermissions()
    var
        LookupValue: Record LookupValue;
    begin
        //[SCENARIO #0045] Modify lookup value without permissions

        //[GIVEN] Unrestricted starting permissions
        SetUnrestrictedStartingPermissions();
        //[GIVEN] Create lookup value
        CreateLookupValue(LookupValue);
        //[GIVEN] Full base permissions
        SetFullBasePermissions();

        //[WHEN] Modify lookup value
        asserterror ModifyLookupValue(LookupValue);

        //[THEN] Modify permissions error thrown
        VerifyPermissionsErrorThrown('Modify');
    end;

    [Test]
    procedure ModifyLookupValueWithPermissions()
    var
        LookupValue: Record LookupValue;
    begin
        //[SCENARIO #0046] Modify lookup value with permissions

        //[GIVEN] Unrestricted starting permissions
        SetUnrestrictedStartingPermissions();
        //[GIVEN] Create lookup value
        CreateLookupValue(LookupValue);
        //[GIVEN] Full base permissions extended with Lookup Value
        SetFullBasePermissionsExtendedWithLookupValue();

        //[WHEN] Modify lookup value
        ModifyLookupValue(LookupValue);

        //[THEN] Lookup value exists
        VerifyLookupValueExists(LookupValue.Code);
    end;

    [Test]
    procedure DeleteLookupValueWithoutPermissions()
    var
        LookupValue: Record LookupValue;
    begin
        //[SCENARIO #0047] Delete lookup value without permissions

        //[GIVEN] Unrestricted starting permissions
        SetUnrestrictedStartingPermissions();
        //[GIVEN] Create lookup value
        CreateLookupValue(LookupValue);
        //[GIVEN] Full base permissions
        SetFullBasePermissions();

        //[WHEN] Delete lookup value
        asserterror DeleteLookupValue(LookupValue);

        //[THEN] Delete permissions error thrown
        VerifyPermissionsErrorThrown('Delete');
    end;

    [Test]
    procedure DeleteLookupValueWithPermissions()
    var
        LookupValue: Record LookupValue;
    begin
        //[SCENARIO #0048] Delete lookup value with permissions

        //[GIVEN] Unrestricted starting permissions
        SetUnrestrictedStartingPermissions();
        //[GIVEN] Create lookup value
        CreateLookupValue(LookupValue);
        //[GIVEN] Full base permissions extended with Lookup Value
        SetFullBasePermissionsExtendedWithLookupValue();

        //[WHEN] Delete lookup value
        DeleteLookupValue(LookupValue);

        //[THEN] Lookup value does not exist
        VerifyLookupValueDoesNotExist(LookupValue.Code);
    end;

    [Test]
    procedure OpenLookupValuesPageWithoutPermissions()
    var
        LookupValues: TestPage LookupValues;
    begin
        //[SCENARIO #0049] Open Lookup Values Page without permissions

        //[GIVEN] Unrestricted starting permissions
        SetUnrestrictedStartingPermissions();
        //[Given] Lookup value
        CreateLookupValueCode();
        //[GIVEN] Full base permissions
        SetFullBasePermissions();

        //[WHEN] Open Lookup Values page
        asserterror LookupValues.OpenView();

        //[THEN] Read permissions error thrown
        VerifyPermissionsErrorThrown('Read');
    end;

    [Test]
    procedure OpenLookupValuesPageWithPermissions()
    var
        LookupValues: TestPage LookupValues;
    begin
        //[SCENARIO #0050] Open Lookup Values Page with permissions

        //[GIVEN] Full base starting permissions extended with Lookup Value permissions
        SetFullBaseStartingPermissionsExtendedWithLookupValue();
        //[GIVEN] Clear last error
        ClearLastError();

        //[WHEN] Open Lookup Values page
        LookupValues.OpenView();

        //[THEN] No error thrown
        VerifyNoErrorThrown();
    end;

    [Test]
    procedure CheckLookupValueOnCustomerCardWithoutPermissions()
    var
        CustomerCard: TestPage "Customer Card";
    begin
        //[SCENARIO #0051] Check lookup value on customer card without permissions

        //[GIVEN] Full base starting permissions
        SetFullBaseStartingPermissions();

        //[WHEN] Open customer card
        CustomerCard.OpenView();

        //[THEN] Lookup value field not shown
        VerifyLookupValueNotShownOnCustomerCard(CustomerCard);
    end;

    [Test]
    procedure CheckLookupValueOnCustomerCardWithPermissions()
    var
        CustomerCard: TestPage "Customer Card";
    begin
        //[SCENARIO #0052] Check lookup value on customer card with permissions

        //[GIVEN] Full base starting permissions extended with Lookup Value permissions
        SetFullBaseStartingPermissionsExtendedWithLookupValue();

        //[WHEN] Open customer card
        CustomerCard.OpenView();

        //[THEN] Lookup value field shown
        VerifyLookupValueShownOnCustomerCard(CustomerCard);
    end;

    [Test]
    procedure CheckLookupValueOnCustomerListWithoutPermissions()
    var
        CustomerList: TestPage "Customer List";
    begin
        //[SCENARIO #0053] Check lookup value on customer list without permissions

        //[GIVEN] Full base starting permissions
        SetFullBaseStartingPermissions();

        //[WHEN] Open customer list
        CustomerList.OpenView();

        //[THEN] Lookup value field not shown
        VerifyLookupValueNotShownOnCustomerList(CustomerList);
    end;

    [Test]
    procedure CheckLookupValueOnCustomerListWithPermissions()
    var
        CustomerList: TestPage "Customer List";
    begin
        //[SCENARIO #0054] Check lookup value on customer list with permissions

        //[GIVEN] Full base starting permissions extended with Lookup Value permissions
        SetFullBaseStartingPermissionsExtendedWithLookupValue();

        //[WHEN] Open customer list
        CustomerList.OpenView();

        //[THEN] Lookup value field shown
        VerifyLookupValueShownOnCustomerList(CustomerList);
    end;

    local procedure SetFullBaseStartingPermissions()
    begin
        LibraryLowerPermissions.StartLoggingNAVPermissions('D365 BUS FULL ACCESS');
    end;

    local procedure SetFullBaseStartingPermissionsExtendedWithLookupValue()
    begin
        SetFullBaseStartingPermissions();
        LibraryLowerPermissions.AddPermissionSet('LOOKUP VALUE');
    end;

    local procedure SetFullBasePermissions()
    begin
        LibraryLowerPermissions.SetO365BusFull();
    end;

    local procedure SetFullBasePermissionsExtendedWithLookupValue()
    begin
        SetFullBasePermissions();
        LibraryLowerPermissions.AddPermissionSet('LOOKUP VALUE');
    end;

    local procedure SetUnrestrictedStartingPermissions()
    begin
        LibraryLowerPermissions.StartLoggingNAVPermissions('SUPER');
    end;

    local procedure CreateLookupValue(var LookupValue: Record LookupValue)
    begin
        LookupValue.Init();
        LookupValue.Validate(
            Code,
            LibraryUtility.GenerateRandomCode(LookupValue.FieldNo(Code),
            Database::LookupValue));
        LookupValue.Validate(Description, LookupValue.Code);
        LookupValue.Insert();
    end;

    local procedure CreateLookupValueCode(): Code[10]
    begin
        exit(LibraryLookupValue.CreateLookupValueCode());
    end;

    local procedure ReadLookupValueCode(LookupValueCode: Code[10])
    var
        LookupValue: Record LookupValue;
    begin
        LookupValue.Get(LookupValueCode);
    end;

    local procedure ModifyLookupValue(var LookupValue: Record LookupValue)
    begin
        LookupValue.Description := LibraryUtility.GenerateRandomText(MaxStrLen(LookupValue.Code));
        LookupValue.Modify();
    end;

    local procedure DeleteLookupValue(var LookupValue: Record LookupValue)
    begin
        LookupValue.Delete();
    end;

    local procedure VerifyPermissionsErrorThrown(PermissionType: Text)
    var
        YouDoNotHavePermissions: Label 'You do not have the following permissions on TableData LookupValue: %1';
    begin
        Assert.ExpectedError(StrSubstNo(YouDoNotHavePermissions, PermissionType));
    end;

    local procedure VerifyLookupValueExists(LookupValueCode: Code[10])
    var
        LookupValue: Record LookupValue;
    begin
        LookupValue.SetRange(Code, LookupValueCode);
        Assert.RecordIsNotEmpty(LookupValue);
    end;

    local procedure VerifyLookupValueDoesNotExist(LookupValueCode: Code[10])
    var
        LookupValue: Record LookupValue;
    begin
        LookupValue.SetRange(Code, LookupValueCode);
        Assert.RecordIsEmpty(LookupValue);
    end;

    local procedure VerifyNoErrorThrown()
    begin
        Assert.AreEqual('', GetLastErrorText(), '');
    end;

    local procedure VerifyLookupValueNotShownOnCustomerCard(var CustomerCard: TestPage "Customer Card")
    var
        NotFoundOnPage: Label 'is not found on the page.';
    begin
        asserterror Assert.IsFalse(CustomerCard."Lookup Value Code".Visible(), 'Visible');
        Assert.ExpectedError(NotFoundOnPage);
        CustomerCard.Close();
    end;

    local procedure VerifyLookupValueShownOnCustomerCard(var CustomerCard: TestPage "Customer Card")
    begin
        Assert.IsTrue(CustomerCard."Lookup Value Code".Visible(), 'Not visible');
        CustomerCard.Close();
    end;

    local procedure VerifyLookupValueNotShownOnCustomerList(var CustomerList: TestPage "Customer List")
    var
        NotFoundOnPage: Label 'is not found on the page.';
    begin
        asserterror Assert.IsFalse(CustomerList."Lookup Value Code".Visible(), 'Visible');
        Assert.ExpectedError(NotFoundOnPage);
        CustomerList.Close();
    end;

    local procedure VerifyLookupValueShownOnCustomerList(var CustomerList: TestPage "Customer List")
    begin
        Assert.IsTrue(CustomerList."Lookup Value Code".Visible(), 'Not visible');
        CustomerList.Close();
    end;
}