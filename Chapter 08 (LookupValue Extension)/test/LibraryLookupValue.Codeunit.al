codeunit 80000 "Library - Lookup Value"
{
    var
        LibraryUtility: Codeunit "Library - Utility";

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
}