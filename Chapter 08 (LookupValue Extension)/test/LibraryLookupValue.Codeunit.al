codeunit 80000 "Library - Lookup Value"
{
    var
        LibraryUtility: Codeunit "Library - Utility";
        Assert: Codeunit "Library Assert";
        LibraryMessages: Codeunit "Library - Messages";

    procedure CreateLookupValueCode(): Code[10]
    var
        LookupValue: Record LookupValue;
    begin
        LookupValue.Init();
        LookupValue.Validate(Code, LibraryUtility.GenerateRandomCode(LookupValue.FieldNo(Code), Database::LookupValue));
        LookupValue.Validate(Description, LookupValue.Code);
        LookupValue.Insert();
        exit(LookupValue.Code);
    end;

    procedure VerifyLookupValueOnCustomer(CustomerNo: Code[20]; LookupValueCode: Code[10])
    var
        Customer: Record Customer;
    begin
        Customer.Get(CustomerNo);
        Assert.AreEqual(LookupValueCode, Customer."Lookup Value Code", LibraryMessages.GetFieldOnTableTxt(Customer.FieldCaption("Lookup Value Code"), Customer.TableCaption()));
    end;
}