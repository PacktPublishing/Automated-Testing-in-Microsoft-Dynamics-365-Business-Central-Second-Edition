codeunit 50005 "CustomerTemplEvents"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Customer Templ. Mgt.", 'OnApplyTemplateOnBeforeCustomerModify', '', false, false)]
    internal procedure OnApplyTemplateOnBeforeCustomerModifyEvent(var Customer: Record Customer; CustomerTempl: Record "Customer Templ.");
    begin
        Customer."Lookup Value Code" := CustomerTempl."Lookup Value Code";
    end;

}