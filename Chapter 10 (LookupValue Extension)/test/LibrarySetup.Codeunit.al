codeunit 80002 "Library - Setup"
{
    procedure UpdateCustomers(LookupValue: Code[10])
    var
        Customer: Record Customer;
    begin
        Customer.ModifyAll("Lookup Value Code", LookupValue);
    end;
}