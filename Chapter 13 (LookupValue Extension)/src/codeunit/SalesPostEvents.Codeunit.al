codeunit 50004 SalesPostEvents
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', false, false)]
    local procedure OnBeforePostSalesDocEvent(SalesHeader: Record "Sales Header")
    begin
        CheckLookupvalueExistsOnSalesHeader(SalesHeader);
    end;

    procedure CheckLookupvalueExistsOnSalesHeader(SalesHeader: Record "Sales Header")
    begin
        SalesHeader.TestField("Lookup Value Code");
    end;
}