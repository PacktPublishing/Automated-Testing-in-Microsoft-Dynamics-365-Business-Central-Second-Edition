codeunit 81002 "LookupValue UT Cust. Template"
{
    Subtype = Test;

    trigger OnRun()
    begin
        //[FEATURE] LookupValue UT Customer Template
    end;

    var
        Assert: Codeunit "Library Assert";
        LibraryUtility: Codeunit "Library - Utility";
        LibraryTemplates: Codeunit "Library - Templates";
        LibraryLookupValue: Codeunit "Library - Lookup Value";
        LibraryMessages: Codeunit "Library - Messages";
        isInitialized: Boolean;

    // Instruction NOTES
    // (1) Replacing the argument LookupValueCode in verification call, i.e. [THEN] clause, should make any test fail
    // (2) Making field "Lookup Value Code", on any of the related pages, Visible=false should make any UI test fail


    [Test]
    procedure AssignLookupValueToCustomerTemplate()
    //[FEATURE] LookupValue UT Customer Template
    var
        CustomerTemplate: Record "Customer Templ.";
        LookupValueCode: Code[10];
    begin
        //[SCENARIO #00012] Assign lookup value to customer

        //[GIVEN] A lookup value
        LookupValueCode := CreateLookupValueCode();
        //[GIVEN] A customer template
        CreateCustomerTemplate(CustomerTemplate);

        //[WHEN] Set lookup value on customer template
        SetLookupValueOnCustomerTemplate(CustomerTemplate, LookupValueCode);

        //[THEN] Customer template has lookup value code field populated
        VerifyLookupValueOnCustomerTemplate(CustomerTemplate.Code, LookupValueCode);
    end;

    [Test]
    procedure AssignNonExistingLookupValueToCustomerTemplate()
    //[FEATURE] LookupValue UT Customer Template
    var
        CustomerTemplate: Record "Customer Templ.";
        LookupValueCode: Code[10];
    begin
        //[SCENARIO #00013] Assign non-existing lookup value to customer template

        //[GIVEN] A non-existing lookup value
        LookupValueCode := 'SC #0013';
        //[GIVEN] A customer template record variable
        // See local variable CustomerTemplate

        //[WHEN] Set non-existing lookup value to customer template
        asserterror SetLookupValueOnCustomerTemplate(CustomerTemplate, LookupValueCode);

        //[THEN] Non existing lookup value error was thrown
        VerifyNonExistingLookupValueError(LookupValueCode);
    end;

    [Test]
    procedure AssignLookupValueToCustomerTemplateCard()
    //[FEATURE] LookupValue UT Customer Template UI
    var
        CustomerTemplateCard: TestPage "Customer Templ. Card";
        CustomerTemplateCode: Code[10];
        LookupValueCode: Code[10];
    begin
        //[SCENARIO #00014] Assign lookup value on customer template card

        //[GIVEN] A lookup value
        LookupValueCode := CreateLookupValueCode();
        //[GIVEN] A customer template card
        CreateCustomerTemplateCard(CustomerTemplateCard);

        //[WHEN] Set lookup value on customer template card
        CustomerTemplateCode := SetLookupValueOnCustomerTemplateCard(CustomerTemplateCard, LookupValueCode);

        //[THEN] Customer template has lookup value code field populated
        VerifyLookupValueOnCustomerTemplate(CustomerTemplateCode, LookupValueCode);
    end;

    local procedure CreateLookupValueCode(): Code[10]
    begin
        exit(LibraryLookupValue.CreateLookupValueCode())
    end;

    local procedure CreateCustomerTemplate(var CustomerTemplate: record "Customer Templ.")
    begin
        LibraryTemplates.CreateCustomerTemplate(CustomerTemplate);
    end;

    local procedure CreateCustomerTemplateCard(var CustomerTemplateCard: TestPage "Customer Templ. Card")
    var
        CustomerTemplate: Record "Customer Templ.";
    begin
        CustomerTemplateCard.OpenNew();
        CustomerTemplateCard.Code.SetValue(LibraryUtility.GenerateRandomCode(CustomerTemplate.FieldNo(Code), Database::"Customer Templ."));
    end;

    local procedure SetLookupValueOnCustomerTemplate(var CustomerTemplate: record "Customer Templ."; LookupValueCode: Code[10])
    begin
        CustomerTemplate.Validate("Lookup Value Code", LookupValueCode);
        CustomerTemplate.Modify();
    end;

    local procedure SetLookupValueOnCustomerTemplateCard(var CustomerTemplateCard: TestPage "Customer Templ. Card"; LookupValueCode: Code[10]) CustomerTemplateCode: Code[10]
    begin
        Assert.IsTrue(CustomerTemplateCard."Lookup Value Code".Editable(), 'Editable');
        CustomerTemplateCard."Lookup Value Code".SetValue(LookupValueCode);
        CustomerTemplateCode := CustomerTemplateCard."Code".Value();
        CustomerTemplateCard.Close();
    end;

    local procedure VerifyLookupValueOnCustomerTemplate(CustomerTemplateCode: Code[10]; LookupValueCode: Code[10])
    var
        CustomerTemplate: Record "Customer Templ.";
    begin
        CustomerTemplate.Get(CustomerTemplateCode);
        Assert.AreEqual(LookupValueCode, CustomerTemplate."Lookup Value Code", LibraryMessages.GetFieldOnTableTxt(CustomerTemplate.FieldCaption("Lookup Value Code"), CustomerTemplate.TableCaption()));
    end;

    local procedure VerifyNonExistingLookupValueError(LookupValueCode: Code[10])
    var
        CustomerTemplate: Record "Customer Templ.";
        LookupValue: Record LookupValue;
    begin
        Assert.ExpectedError(
    LibraryMessages.GetValueCannotBeFoundInTableTxt(
        CustomerTemplate.FieldCaption("Lookup Value Code"),
        CustomerTemplate.TableCaption(),
        LookupValueCode,
        LookupValue.TableCaption()));
    end;
}