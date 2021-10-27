codeunit 81026 "LookupValue UT Inheritance"
{
    // Generated on 5-8-2021 at 11:57 by lvanvugt

    Subtype = Test;

    trigger OnRun()
    begin
        // [FEATURE] LookupValue UT Inheritance
    end;

    var
        Assert: Codeunit "Library Assert";
        LibraryLookupValue: Codeunit "Library - Lookup Value";
        LibraryMessages: Codeunit "Library - Messages";

    [Test]
    procedure CheckInheritLookupValueFromCustomer()
    // [FEATURE] LookupValue UT Inheritance
    var
        Customer: Record Customer;
        SalesHeader: Record "Sales Header";
    begin
        // [SCENARIO #0104] Check InheritLookupValueFromCustomer

        // [GIVEN] Customer with Lookup value
        Customer."Lookup Value Code" := 'SC #0104';
        // [GIVEN] Sales header without lookup value
        // See local variable SalesHeader

        // [WHEN] Trigger InheritLookupValueFromCustomer
        TriggerInheritLookupValueFromCustomer(SalesHeader, Customer);

        // [THEN] Lookup value on sales document is populated with lookup value of customer
        VerifyLookupValueOnSalesHeader(SalesHeader, Customer."Lookup Value Code");
    end;

    [Test]
    procedure CheckApplyLookupValueFromCustomerTemplateFromContact()
    // [FEATURE] LookupValue UT Inheritance
    var
        Customer: Record Customer;
        CustomerTempl: Record "Customer Templ.";
    begin
        // [SCENARIO #0105] Check ApplyLookupValueFromCustomerTemplate from Contact

        // [GIVEN] Customer template with lookup value
        CreateCustomerTemplateWithLookupValue(CustomerTempl);
        // [GIVEN] Customer
        // See local variable Customer

        // [WHEN] Trigger ApplyLookupValueFromCustomerTemplate
        TriggerOnCreateCustomerFromTemplateOnBeforeCustomerInsertEvent(Customer, CustomerTempl.Code);

        // [THEN] Lookup value on customer is populated with lookup value of customer template
        VerifyLookupValueOnCustomer(Customer, CustomerTempl."Lookup Value Code");
    end;

    local procedure CreateCustomerTemplateWithLookupValue(var CustomerTemplate: Record "Customer Templ."): Code[10]
    var
        LibraryTemplates: Codeunit "Library - Templates";
    begin
        LibraryTemplates.CreateCustomerTemplate(CustomerTemplate);
        CustomerTemplate.Validate("Lookup Value Code", CreateLookupValueCode());
        CustomerTemplate.Modify();
        exit(CustomerTemplate."Lookup Value Code");
    end;

    local procedure CreateLookupValueCode(): Code[10]
    begin
        exit(LibraryLookupValue.CreateLookupValueCode())
    end;

    local procedure TriggerInheritLookupValueFromCustomer(var SalesHeader: Record "Sales Header"; SellToCustomer: Record Customer)
    var
        SalesHeaderEvents: Codeunit SalesHeaderEvents;
    begin
        SalesHeaderEvents.InheritLookupValueFromCustomer(SalesHeader, SellToCustomer)
    end;

    local procedure TriggerApplyLookupValueFromCustomerTemplate(var Customer: Record Customer; CustomerTempl: Record "Customer Templ.")
    var
        CustomerTemplEvents: Codeunit CustomerTemplEvents;
    begin
        CustomerTemplEvents.ApplyLookupValueFromCustomerTemplate(Customer, CustomerTempl);
    end;

    local procedure TriggerOnCreateCustomerFromTemplateOnBeforeCustomerInsertEvent(var Cust: Record Customer; CustomerTemplate: Code[20])
    var
        ContactEvents: Codeunit ContactEvents;
    begin
        ContactEvents.ApplyLookupValueFromCustomerTemplate(Cust, CustomerTemplate);
    end;

    local procedure VerifyLookupValueOnSalesHeader(SalesHeader: Record "Sales Header"; LookupValueCode: Code[10])
    begin
        Assert.AreEqual(LookupValueCode, SalesHeader."Lookup Value Code", LibraryMessages.GetFieldOnTableTxt(SalesHeader.FieldCaption("Lookup Value Code"), SalesHeader.TableCaption()));
    end;

    local procedure VerifyLookupValueOnCustomer(Customer: Record Customer; LookupValueCode: Code[10])
    begin
        Assert.AreEqual(LookupValueCode, Customer."Lookup Value Code", LibraryMessages.GetFieldOnTableTxt(Customer.FieldCaption("Lookup Value Code"), Customer.TableCaption()));
    end;
}