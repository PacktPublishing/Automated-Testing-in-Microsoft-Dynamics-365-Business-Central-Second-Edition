codeunit 80050 "Library - Sales Events"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Library - Sales", 'OnAfterCreateCustomer', '', false, false)]
    local procedure OnAfterCreateCustomerEvent(var Customer: Record Customer)
    begin
        SetLookupValueOnCustomer(Customer);
    end;

    local procedure SetLookupValueOnCustomer(var Customer: Record Customer)
    var
        LibraryLookupValue: Codeunit "Library - Lookup Value";
    begin
        Customer.Validate("Lookup Value Code", LibraryLookupValue.CreateLookupValueCode());
        Customer.Modify();
    end;
}