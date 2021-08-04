codeunit 50003 "ContactEvents"
{
    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnCreateCustomerFromTemplateOnBeforeCustomerInsert', '', false, false)]
    internal procedure OnCreateCustomerFromTemplateOnBeforeCustomerInsertEvent(var Cust: Record Customer; CustomerTemplate: Code[20]; var Contact: Record Contact)
    var
        CustomerTempl: Record "Customer Templ.";
    begin
        CustomerTempl.Get(CustomerTemplate);
        Cust."Lookup Value Code" := CustomerTempl."Lookup Value Code";
    end;
}