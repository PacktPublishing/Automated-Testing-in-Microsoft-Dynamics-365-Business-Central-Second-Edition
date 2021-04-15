codeunit 50003 "ContactEvents"
{
    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnCreateCustomerFromTemplateOnAfterApplyCustomerTemplate', '', false, false)]
    local procedure OnCreateCustomerOnTransferFieldsFromTemplateEvent(var Customer: Record Customer; CustomerTemplate: Record "Customer Templ.")
    begin
        Customer."Lookup Value Code" := CustomerTemplate."Lookup Value Code";
    end;
}