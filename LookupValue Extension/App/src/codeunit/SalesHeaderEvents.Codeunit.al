codeunit 50000 SalesHeaderEvents
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterCopySellToCustomerAddressFieldsFromCustomer', '', false, false)]
    local procedure OnAfterCopySellToCustomerAddressFieldsFromCustomerEvent(var SalesHeader: Record "Sales Header"; SellToCustomer: Record Customer)
    begin
        InheritLookupValueFromCustomer(SalesHeader, SellToCustomer);
    end;

    procedure InheritLookupValueFromCustomer(var SalesHeader: Record "Sales Header"; SellToCustomer: Record Customer)
    begin
        SalesHeader."Lookup Value Code" := SellToCustomer."Lookup Value Code";
    end;
}