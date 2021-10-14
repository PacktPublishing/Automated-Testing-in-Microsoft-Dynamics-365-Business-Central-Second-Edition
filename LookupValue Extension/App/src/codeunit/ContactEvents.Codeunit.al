codeunit 50003 ContactEvents
{
    [EventSubscriber(ObjectType::Table, Database::Contact, 'OnCreateCustomerFromTemplateOnBeforeCustomerInsert', '', false, false)]
    local procedure OnCreateCustomerFromTemplateOnBeforeCustomerInsertEvent(var Cust: Record Customer; CustomerTemplate: Code[20]; var Contact: Record Contact)
    begin
        ApplyLookupValueFromCustomerTemplate(Cust, CustomerTemplate);
    end;

    procedure ApplyLookupValueFromCustomerTemplate(var Customer: Record Customer; CustomerTemplateCode: Code[20])
    var
        CustomerTempl: Record "Customer Templ.";
    begin
        CustomerTempl.Get(CustomerTemplateCode);
        Customer."Lookup Value Code" := CustomerTempl."Lookup Value Code";
    end;
}