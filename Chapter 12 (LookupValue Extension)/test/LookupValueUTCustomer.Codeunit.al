codeunit 81000 "LookupValue UT Customer"
{
    Subtype = Test;

    trigger OnRun()
    begin
        //[FEATURE] LookupValue UT Customer
    end;

    var
        Assert: Codeunit "Library Assert";
        LibrarySales: Codeunit "Library - Sales";
        LibraryLookupValue: Codeunit "Library - Lookup Value";
        LibraryMessages: Codeunit "Library - Messages";

    // Instruction NOTES
    // (1) Replacing the argument LookupValueCode in verification call, i.e. [THEN] clause, should make any test fail
    // (2) Making field "Lookup Value Code", on any of the related pages, Visible=false should make any UI test fail

    [Test]
    procedure AssignLookupValueToCustomer()
    var
        Customer: Record Customer;
        LookupValueCode: Code[10];
    begin
        //[SCENARIO #0001] Assign lookup value to customer

        //[GIVEN] Lookup value
        LookupValueCode := CreateLookupValueCode();
        //[GIVEN] Customer
        CreateCustomer(Customer);

        //[WHEN] Set lookup value on customer
        SetLookupValueOnCustomer(Customer, LookupValueCode);

        //[THEN] Customer has lookup value field populated
        VerifyLookupValueOnCustomer(Customer."No.", LookupValueCode);
    end;

    [Test]
    procedure AssignNonExistingLookupValueToCustomer()
    var
        Customer: Record Customer;
        LookupValueCode: Code[10];
    begin
        //[SCENARIO #0002] Assign non-existing lookup value to customer

        //[GIVEN] Non-existing lookup value
        LookupValueCode := 'SC #0002';
        //[GIVEN] Customer record variable
        // See local variable Customer

        //[WHEN] Set non-existing lookup value on customer
        asserterror SetLookupValueOnCustomer(Customer, LookupValueCode);

        //[THEN] Non existing lookup value error thrown
        VerifyNonExistingLookupValueError(LookupValueCode);
    end;

    [Test]
    [HandlerFunctions('HandleConfigTemplates')]
    procedure AssignLookupValueToCustomerCard()
    var
        CustomerCard: TestPage "Customer Card";
        CustomerNo: Code[20];
        LookupValueCode: Code[10];
    begin
        //[SCENARIO #0003] Assign lookup value on customer card

        //[GIVEN] Lookup value
        LookupValueCode := CreateLookupValueCode();
        //[GIVEN] Customer card
        CreateCustomerCard(CustomerCard);

        //[WHEN] Set lookup value on customer card
        CustomerNo := SetLookupValueOnCustomerCard(CustomerCard, LookupValueCode);

        //[THEN] Customer has lookup value field populated
        VerifyLookupValueOnCustomer(CustomerNo, LookupValueCode);
    end;

    local procedure CreateLookupValueCode(): Code[10]
    begin
        exit(LibraryLookupValue.CreateLookupValueCode())
    end;

    local procedure CreateCustomer(var Customer: Record Customer)
    begin
        LibrarySales.CreateCustomer(Customer);
    end;

    local procedure SetLookupValueOnCustomer(var Customer: Record Customer; LookupValueCode: Code[10])
    begin
        Customer.Validate("Lookup Value Code", LookupValueCode);
        Customer.Modify();
    end;

    local procedure CreateCustomerCard(var CustomerCard: TestPage "Customer Card")
    begin
        CustomerCard.OpenNew();
    end;

    local procedure SetLookupValueOnCustomerCard(var CustomerCard: TestPage "Customer Card"; LookupValueCode: Code[10]) CustomerNo: Code[20]
    begin
        Assert.IsTrue(CustomerCard."Lookup Value Code".Editable(), 'Editable');
        CustomerCard."Lookup Value Code".SetValue(LookupValueCode);
        CustomerNo := CustomerCard."No.".Value();
        CustomerCard.Close();
    end;

    local procedure VerifyLookupValueOnCustomer(CustomerNo: Code[20]; LookupValueCode: Code[10])
    begin
        LibraryLookupValue.VerifyLookupValueOnCustomer(CustomerNo, LookupValueCode);
    end;

    local procedure VerifyNonExistingLookupValueError(LookupValueCode: Code[10])
    var
        Customer: Record Customer;
        LookupValue: Record LookupValue;
    begin
        Assert.ExpectedError(
            LibraryMessages.GetValueCannotBeFoundInTableTxt(
                Customer.FieldCaption("Lookup Value Code"),
                Customer.TableCaption(),
                LookupValueCode,
                LookupValue.TableCaption()));
    end;

    [ModalPageHandler]
    procedure HandleConfigTemplates(var ConfigTemplates: TestPage "Config Templates")
    begin
        ConfigTemplates.OK().Invoke();
    end;
}