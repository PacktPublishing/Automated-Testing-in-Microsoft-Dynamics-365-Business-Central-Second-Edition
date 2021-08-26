codeunit 50004 "SalesPostEvents"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', false, false)]
    internal procedure OnBeforePostSalesDocEvent(SalesHeader: Record "Sales Header")
    begin
        SalesHeader.TestField("Lookup Value Code");
    end;
}