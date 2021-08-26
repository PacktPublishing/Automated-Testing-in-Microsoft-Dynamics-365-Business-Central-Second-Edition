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
    procedure CheckOnAfterCopySellToCustomerAddressFieldsFromCustomerEventSubscriber()
    // [FEATURE] LookupValue UT Inheritance
    var
        Customer: Record Customer;
        SalesHeader: Record "Sales Header";
    begin
        // [SCENARIO #0104] Check OnAfterCopySellToCustomerAddressFieldsFromCustomerEvent subscriber

        // [GIVEN] Customer with Lookup value
        Customer."Lookup Value Code" := 'SC #0104';
        // [GIVEN] Sales header without lookup value
        // See local variable SalesHeader

        // [WHEN] OnAfterCopySellToCustomerAddressFieldsFromCustomerEvent is triggered
        TriggerOnAfterCopySellToCustomerAddressFieldsFromCustomerEvent(SalesHeader, Customer);

        // [THEN] Lookup value on sales document is populated with lookup value of customer
        VerifyLookupValueOnSalesHeader(SalesHeader, Customer."Lookup Value Code");
    end;

    [Test]
    procedure CheckOnCreateCustomerFromTemplateOnBeforeCustomerInsertEventSubscriber()
    // [FEATURE] LookupValue UT Inheritance
    var
        Customer: Record Customer;
        CustomerTempl: Record "Customer Templ.";
    begin
        // [SCENARIO #0105] Check OnCreateCustomerFromTemplateOnBeforeCustomerInsertEvent subscriber

        // [GIVEN] Customer template with lookup value
        CreateCustomerTemplateWithLookupValue(CustomerTempl);
        // [GIVEN] Customer
        // See local variable Customer

        // [WHEN] OnCreateCustomerFromTemplateOnBeforeCustomerInsertEvent is triggered
        TriggerOnCreateCustomerFromTemplateOnBeforeCustomerInsertEvent(Customer, CustomerTempl.Code);

        // [THEN] Lookup value on customer is populated with lookup value of customer template
        VerifyLookupValueOnCustomer(Customer, CustomerTempl."Lookup Value Code");
    end;

    [Test]
    procedure CheckOnApplyTemplateOnBeforeCustomerModifyEventSubscriber()
    // [FEATURE] LookupValue UT Inheritance
    var
        Customer: Record Customer;
        CustomerTempl: Record "Customer Templ.";
    begin
        // [SCENARIO #0106] Check OnApplyTemplateOnBeforeCustomerModifyEvent subscriber

        // [GIVEN] Customer template with lookup value
        CustomerTempl."Lookup Value Code" := 'SC #0106';
        // [GIVEN] Customer
        // See local variable Customer

        // [WHEN] OnApplyTemplateOnBeforeCustomerModifyEvent is triggered
        TriggerOnApplyTemplateOnBeforeCustomerModifyEvent(Customer, CustomerTempl);

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

    local procedure TriggerOnAfterCopySellToCustomerAddressFieldsFromCustomerEvent(var SalesHeader: Record "Sales Header"; SellToCustomer: Record Customer)
    var
        SalesHeaderEvents: Codeunit SalesHeaderEvents;
    begin
        SalesHeaderEvents.OnAfterCopySellToCustomerAddressFieldsFromCustomerEvent(SalesHeader, SellToCustomer)
    end;

    local procedure TriggerOnApplyTemplateOnBeforeCustomerModifyEvent(var Customer: Record Customer; CustomerTempl: Record "Customer Templ.")
    var
        CustomerTemplEvents: Codeunit CustomerTemplEvents;
    begin
        CustomerTemplEvents.OnApplyTemplateOnBeforeCustomerModifyEvent(Customer, CustomerTempl);
    end;

    local procedure TriggerOnCreateCustomerFromTemplateOnBeforeCustomerInsertEvent(var Cust: Record Customer; CustomerTemplate: Code[20])
    var
        Contact: Record Contact;
        ContactEvents: Codeunit ContactEvents;
    begin
        ContactEvents.OnCreateCustomerFromTemplateOnBeforeCustomerInsertEvent(Cust, CustomerTemplate, Contact);
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