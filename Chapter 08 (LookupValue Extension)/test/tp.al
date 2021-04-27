codeunit 81010 TestPermissions
{
    Subtype = Test;

    trigger OnRun()
    begin
        //[FEATURE] LookupValue Test Permissions
    end;

    var
        Assert: Codeunit "Library Assert";
        LibraryUtility: Codeunit "Library - Utility";
        LibrarySales: Codeunit "Library - Sales";
        LibraryLowerPermissions: Codeunit "Library - Lower Permissions";

    // Instruction NOTES
    // (1) Replacing the argument LookupValueCode in verification call, i.e. [THEN] clause, should make any test fail
    // (2) Making field "Lookup Value Code", on any of the related pages, Visible=false should make any UI test fail

    [Test]
    [TestPermissions(TestPermissions::Disabled)]
    procedure AssignLookupValueToCustomerDisabled()
    begin
        AssignLookupValueToCustomer();
    end;

    [Test]
    [TestPermissions(TestPermissions::NonRestrictive)]
    procedure AssignLookupValueToCustomerNonRestrictive()
    begin
        AssignLookupValueToCustomer();
    end;

    [Test]
    [TestPermissions(TestPermissions::Restrictive)]
    procedure AssignLookupValueToCustomerRestrictive()
    begin
        AssignLookupValueToCustomer();
    end;

    procedure AssignLookupValueToCustomer()
    var
        Customer: Record Customer;
        LookupValueCode: Code[10];
    begin
        //[SCENARIO #xxxx] Assign lookup value to customer
        // LibraryLowerPermissions.SetItemView();

        //[GIVEN] Lookup value
        LookupValueCode := CreateLookupValueCode();
        //[GIVEN] Customer
        CreateCustomer(Customer);

        //[WHEN] Set lookup value on customer
        LibraryLowerPermissions.SetItemView();
        SetLookupValueOnCustomer(Customer, LookupValueCode);

        //[THEN] Customer has lookup value field populated
        VerifyLookupValueOnCustomer(Customer."No.", LookupValueCode);
    end;

    local procedure CreateLookupValueCode(): Code[10]
    var
        LookupValue: Record LookupValue;
    begin
        LookupValue.Init();
        LookupValue.Validate(
            Code,
            LibraryUtility.GenerateRandomCode(LookupValue.FieldNo(Code),
            Database::LookupValue));
        LookupValue.Validate(Description, LookupValue.Code);
        LookupValue.Insert();
        exit(LookupValue.Code);
    end;

    local procedure CreateCustomer(var Customer: record Customer)
    begin
        LibrarySales.CreateCustomer(Customer);
    end;

    local procedure SetLookupValueOnCustomer(var Customer: record Customer; LookupValueCode: Code[10])
    begin
        Customer.Validate("Lookup Value Code", LookupValueCode);
        Customer.Modify();
    end;

    local procedure VerifyLookupValueOnCustomer(CustomerNo: Code[20]; LookupValueCode: Code[10])
    var
        Customer: Record Customer;
        FieldOnTableTxt: Label '%1 on %2';
    begin
        Customer.Get(CustomerNo);
        Assert.AreEqual(
            LookupValueCode,
            Customer."Lookup Value Code",
            StrSubstNo(
                FieldOnTableTxt,
                Customer.FieldCaption("Lookup Value Code"),
                Customer.TableCaption())
            );
    end;
}