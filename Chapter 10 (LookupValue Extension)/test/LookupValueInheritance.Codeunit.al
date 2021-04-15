codeunit 81006 "LookupValue Inheritance"
{
    Subtype = Test;

    trigger OnRun()
    begin
        //[FEATURE] LookupValue Sales Document / Customer
    end;

    var
        Assert: Codeunit "Library Assert";
        LibrarySales: Codeunit "Library - Sales";
        LibraryVariableStorage: Codeunit "Library - Variable Storage";
        LibraryRapidStart: Codeunit "Library - Rapid Start";
        LibrarySmallBusiness: Codeunit "Library - Small Business";
        LibraryLookupValue: Codeunit "Library - Lookup Value";
        LibraryMessages: Codeunit "Library - Messages";
        isInitialized: Boolean;
        LookupValueCode: Code[10];

    // Instruction NOTES
    // (1) Replacing the argument LookupValueCode in verification call, i.e. [THEN] clause, should make any test fail

    [Test]
    procedure InheritLookupValueFromCustomerOnSalesDocument();
    //[FEATURE] LookupValue Sales Document / Customer
    var
        SalesHeader: Record "Sales Header";
        CustomerNo: Code[20];
    begin
        //[SCENARIO #0024] Assign customer lookup value to sales document
        Initialize();

        //[GIVEN] A customer with a lookup value
        CustomerNo := CreateCustomerWithLookupValue(LookupValueCode);
        //[GIVEN] A sales document (invoice) without a lookup value
        CreateSalesHeader(SalesHeader);

        //[WHEN] Set customer on sales header
        SetCustomerOnSalesHeader(SalesHeader, CustomerNo);

        //[THEN] LookupValue on sales document is populated with lookup value of customer
        VerifyLookupValueOnSalesHeader(SalesHeader, LookupValueCode);
    end;

    [Test]
    [HandlerFunctions('HandleConfigTemplates')]
    procedure InheritLookupValueFromConfigurationTemplateToCustomer();
    var
        CustomerNo: Code[20];
        ConfigTemplateCode: Code[10];
    begin
        //[SCENARIO #0028] Create customer from configuration template with lookup value
        Initialize();

        //[GIVEN] A configuration template (customer) with lookup value
        ConfigTemplateCode := CreateCustomerConfigurationTemplateWithLookupValue(LookupValueCode);

        //[WHEN] Create customer from configuration template
        LibraryVariableStorage.Enqueue(ConfigTemplateCode);
        CustomerNo := CreateCustomerFromConfigurationTemplate(ConfigTemplateCode);

        //[THEN] Lookup value on customer is populated with lookup value of configuration template
        VerifyLookupValueOnCustomer(CustomerNo, LookupValueCode);
    end;

    local procedure Initialize()
    var
        LibraryTestsSetup: Codeunit "Library - Tests Setup";
    begin
        if isInitialized then
            exit;

        //[GIVEN] technical: SetSkipOnAfterCreateCustomer (see chapter 9) 
        LibraryTestsSetup.SetSkipOnAfterCreateCustomer(true);
        //[GIVEN] A lookup value
        LookupValueCode := CreateLookupValueCode();

        isInitialized := true;
        Commit();
    end;

    local procedure CreateLookupValueCode(): Code[10]
    begin
        exit(LibraryLookupValue.CreateLookupValueCode())
    end;

    local procedure CreateCustomerWithLookupValue(LookupValueCode: Code[10]): Code[20]
    var
        Customer: Record Customer;
    begin
        LibrarySales.CreateCustomer(Customer);
        Customer.Validate("Lookup Value Code", LookupValueCode);
        Customer.Modify();
        exit(Customer."No.");
    end;

    local procedure CreateSalesHeader(var SalesHeader: record "Sales Header")
    begin
        LibrarySales.CreateSalesHeader(SalesHeader, SalesHeader."Document Type"::Invoice, '');
    end;

    local procedure SetCustomerOnSalesHeader(var SalesHeader: record "Sales Header"; CustomerNo: Code[20])
    begin
        SalesHeader.SetHideValidationDialog(true);
        SalesHeader.Validate("Sell-to Customer No.", CustomerNo);
        SalesHeader.Modify();
    end;

    local procedure CreateCustomerConfigurationTemplateWithLookupValue(LookupValueCode: Code[10]): Code[10]
    // Adopted from Codeunit 132213 Library - Small Business
    var
        ConfigTemplateHeader: record "Config. Template Header";
        Customer: Record Customer;
    begin
        LibraryRapidStart.CreateConfigTemplateHeader(ConfigTemplateHeader);
        ConfigTemplateHeader.Validate("Table ID", Database::Customer);
        ConfigTemplateHeader.Modify(true);

        LibrarySmallBusiness.CreateCustomerTemplateLine(
            ConfigTemplateHeader,
            Customer.FieldNo("Lookup Value Code"),
            Customer.FieldName("Lookup Value Code"),
            LookupValueCode);

        exit(ConfigTemplateHeader.Code);
    end;

    local procedure CreateCustomerFromConfigurationTemplate(ConfigurationTemplateCode: Code[10]) CustomerNo: Code[20]
    var
        CustomerCard: TestPage "Customer Card";
    begin
        CustomerCard.OpenNew();
        CustomerNo := CustomerCard."No.".Value();
        CustomerCard.Close();
    end;

    local procedure VerifyLookupValueOnSalesHeader(var SalesHeader: Record "Sales Header"; LookupValueCode: Code[10])
    begin
        Assert.AreEqual(LookupValueCode, SalesHeader."Lookup Value Code", LibraryMessages.GetFieldOnTableTxt(SalesHeader.FieldCaption("Lookup Value Code"), SalesHeader.TableCaption()));
    end;

    local procedure VerifyLookupValueOnCustomer(CustomerNo: Code[20]; LookupValueCode: Code[10])
    var
        Customer: Record Customer;
    begin
        Customer.Get(CustomerNo);
        Assert.AreEqual(LookupValueCode, Customer."Lookup Value Code", LibraryMessages.GetFieldOnTableTxt(Customer.FieldCaption("Lookup Value Code"), Customer.TableCaption()));
    end;

    [ModalPageHandler]
    procedure HandleConfigTemplates(var ConfigTemplates: TestPage "Config Templates")
    var
        ConfigTemplateCode: Code[10];
        "Value": Variant;
    begin
        LibraryVariableStorage.Dequeue("Value");
        ConfigTemplateCode := "Value";

        ConfigTemplates.GoToKey(ConfigTemplateCode);
        ConfigTemplates.OK().Invoke();
    end;
}