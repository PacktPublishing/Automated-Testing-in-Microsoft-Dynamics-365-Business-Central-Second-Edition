codeunit 80010 "Library - Tests Setup"
{
    procedure SetSkipOnAfterCreateCustomer(Handle: Boolean)
    var
        TestsSetup: Record TestsSetup;
    begin
        if not TestsSetup.Get() then
            EnsureStandardTestsSetupExists();
        TestsSetup."Skip OnAfterCreateCustomer" := Handle;
        TestsSetup.Modify();
    end;

    local procedure EnsureStandardTestsSetupExists()
    var
        TestsSetup: Record TestsSetup;
    begin
        TestsSetup.InsertIfNotExists();
    end;


    procedure SkipOnAfterCreateCustomer(): Boolean
    var
        TestsSetup: Record TestsSetup;
    begin
        if TestsSetup.Get() then
            exit(TestsSetup."Skip OnAfterCreateCustomer")
    end;
}