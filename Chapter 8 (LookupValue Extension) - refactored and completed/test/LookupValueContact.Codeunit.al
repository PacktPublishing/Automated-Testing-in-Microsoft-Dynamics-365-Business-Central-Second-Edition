codeunit 81007 "LookupValue Contact"
{
    Subtype = Test;

    trigger OnRun()
    begin
        //[FEATURE] LookupValue Contact
    end;

    var
        Assert: Codeunit "Library Assert";
        LibraryMarketing: Codeunit "Library - Marketing";
        LibraryTemplates: Codeunit "Library - Templates";
        LibraryLookupValue: Codeunit "Library - Lookup Value";
        LibraryMessages: Codeunit "Library - Messages";

    // Instruction NOTES
    // (1) Replacing the argument LookupValueCode in verification call, i.e. [THEN] clause, should make any test fail

    [Test]
    procedure CreateCustomerFromContactWithLookupValue()
    //[FEATURE] LookupValue Contact
    var
        Contact: Record Contact;
        Customer: Record Customer;
        CustomerTemplate: Record "Customer Templ.";
    begin
        //[SCENARIO #0026] Check that lookup value is inherited from customer template to customer when creating customer from contact

        //[GIVEN] A customer template with lookup value
        CreateCustomerTemplate(CustomerTemplate, UseLookupValue());
        //[GIVEN] A contact
        CreateCompanyContact(Contact);

        //[WHEN] Customer is created from contact
        CreateCustomerFromContact(Contact, CustomerTemplate.Code, Customer);

        //[THEN] Customer has lookup value code field populated with lookup value from customer template
        VerifyLookupValueOnCustomer(Customer."No.", CustomerTemplate."Lookup Value Code");
    end;

    local procedure CreateCustomerTemplate(var CustomerTemplate: Record "Customer Templ."; WithLookupValue: Boolean): Code[10]
    begin
        LibraryTemplates.CreateCustomerTemplate(CustomerTemplate);

        if WithLookupValue then begin
            CustomerTemplate.Validate("Lookup Value Code", CreateLookupValueCode());
            CustomerTemplate.Modify();
        end;
        exit(CustomerTemplate."Lookup Value Code");
    end;

    local procedure CreateLookupValueCode(): Code[10]
    begin
        exit(LibraryLookupValue.CreateLookupValueCode())
    end;

    local procedure UseLookupValue(): Boolean
    begin
        exit(true)
    end;

    local procedure UseNoLookupValue(): Boolean
    begin
        exit(false)
    end;

    local procedure CreateCompanyContact(var Contact: Record Contact);
    begin
        LibraryMarketing.CreateCompanyContact(Contact);
    end;

    local procedure CreateCustomerFromContact(Contact: Record Contact; CustomerTemplateCode: Code[10]; var Customer: Record Customer);
    begin
        Contact.SetHideValidationDialog(true);
        Contact.CreateCustomerFromTemplate(CustomerTemplateCode);
        FindCustomerByCompanyName(Customer, Contact.Name);
    end;

    local procedure FindCustomerByCompanyName(var Customer: Record Customer; CompanyName: Text[50]);
    begin
        Customer.SetRange(Name, CompanyName);
        Customer.FindFirst();
    end;

    local procedure VerifyLookupValueOnCustomer(CustomerNo: Code[20]; LookupValueCode: Code[10])
    var
        Customer: Record Customer;
    begin
        Customer.Get(CustomerNo);
        Assert.AreEqual(LookupValueCode, Customer."Lookup Value Code", LibraryMessages.GetFieldOnTableTxt(Customer.FieldCaption("Lookup Value Code"), Customer.TableCaption()));
    end;
}