codeunit 81090 "APIV1 - LookupValues E2E"
{
    Subtype = Test;
    TestPermissions = Disabled;

    trigger OnRun()
    begin
        // [FEATURE] [Graph] [Customer]
    end;

    var
        Assert: Codeunit "Library Assert";
        LibraryGraphMgt: Codeunit "Library - Graph Mgt";
        LibraryUtility: Codeunit "Library - Utility";
        IsInitialized: Boolean;
        ServiceNameTxt: Label 'lookupvalues';
        EmptyJSONErr: Label 'JSON should not be empty.';

    [Test]
    procedure TestGetLookupValue()
    var
        LookupValue: Record LookupValue;
        Response: Text;
        TargetURL: Text;
    begin
        // [SCENARIO xxxxx] User can Get lookup value with a Get request to the service.
        Initialize();

        // [GIVEN] Lookup value exists in the system.
        CreateLookupValue(LookupValue);

        // [WHEN] The user makes a Get request for given lookup value.
        TargetURL := LibraryGraphMgt.CreateTargetURL(LookupValue.SystemId, Page::"APIV1 - Lookup Values", ServiceNameTxt);
        LibraryGraphMgt.GetFromWebService(Response, TargetURL);

        // [THEN] The response text contains the lookup value information.
        VerifyProperties(Response, LookupValue);
    end;

    [Test]
    procedure TestDeleteLookupValue()
    var
        LookupValue: Record LookupValue;
        LookupValueCode: Code[10];
        TargetURL: Text;
        Response: Text;
    begin
        // [SCENARIO yyyyy] User can delete lookup value by making a DELETE request.
        Initialize();

        // [GIVEN] Lookup value exists.
        CreateLookupValue(LookupValue);
        LookupValueCode := LookupValue.Code;

        // [WHEN] The user makes a DELETE request to the endpoint for lookup value.
        TargetURL := LibraryGraphMgt.CreateTargetURL(LookupValue.SystemId, Page::"APIV1 - Lookup Values", ServiceNameTxt);
        LibraryGraphMgt.DeleteFromWebService(TargetURL, '', Response);

        // [THEN] The response is empty.
        Assert.AreEqual('', Response, 'DELETE response should be empty.');

        // [THEN] Lookup value is no longer in the database.
        LookupValue.SetRange(Code, LookupValueCode);
        Assert.IsTrue(LookupValue.IsEmpty(), 'Lookup Value should be deleted.');
    end;

    [Test]
    procedure TestModifyLookupValue()
    var
        LookupValue: Record LookupValue;
        TempLookupValue: Record LookupValue temporary;
        RequestBody: Text;
        Response: Text;
        TargetURL: Text;
    begin
        // [SCENARIO zzzzz] User can modify lookup value through a PATCH request.
        Initialize();

        // [GIVEN] Lookup value exists.
        CreateLookupValue(LookupValue);
        TempLookupValue.TransferFields(LookupValue);
        TempLookupValue.Description := LibraryUtility.GenerateGUID();
        RequestBody := GetLookupValueJSON(TempLookupValue);

        // [WHEN] The user makes a patch request to the service.
        TargetURL := LibraryGraphMgt.CreateTargetURL(LookupValue.SystemId, Page::"APIV1 - Lookup Values", ServiceNameTxt);
        LibraryGraphMgt.PatchToWebService(TargetURL, RequestBody, Response);

        // [THEN] The response text contains the new values.
        VerifyProperties(Response, TempLookupValue);

        // [THEN] The record in the database contains the new values.
        LookupValue.Get(LookupValue.Code);
        VerifyProperties(Response, LookupValue);
    end;

    local procedure Initialize()
    begin
        if IsInitialized then
            exit;

        IsInitialized := true;
        Commit();
    end;

    local procedure CreateLookupValue(var LookupValue: Record LookupValue)
    var
        LibraryLookupValue: Codeunit "Library - Lookup Value";
    begin
        LibraryLookupValue.CreateLookupValue(LookupValue);
        LookupValue.Description := LibraryUtility.GenerateGUID();
        LookupValue.Modify(true);

        LookupValue.Get(LookupValue.Code);

        Commit(); // Need to commit in order to unlock tables and allow web service to pick up changes.
    end;

    local procedure GetLookupValueJSON(var LookupValue: Record LookupValue): Text
    var
        LookupValueJson: Text;
    begin
        // if LookupValue.Code = '' then
        //     LookupValue.Code := NextCustomerNo();
        // if LookupValue.Description = '' then
        //     LookupValue.Description := LibraryUtility.GenerateGUID();
        LookupValueJson := LibraryGraphMgt.AddPropertytoJSON(LookupValueJson, 'number', LookupValue.Code);
        LookupValueJson := LibraryGraphMgt.AddPropertytoJSON(LookupValueJson, 'displayName', LookupValue.Description);
        exit(LookupValueJson)
    end;

    // local procedure NextCustomerNo(): Code[20]
    // var
    //     LookupValue: Record LookupValue;
    // begin
    //     LookupValue.SetFilter(Code, StrSubstNo('%1*', PrefixTxt));
    //     if LookupValue.FindLast() then
    //         exit(IncStr(LookupValue.Code));

    //     exit(CopyStr(PrefixTxt + '0001', 1, 20));
    // end;

    local procedure VerifyProperties(JSON: Text; LookupValue: Record LookupValue)
    begin
        Assert.AreNotEqual('', JSON, EmptyJSONErr);
        LibraryGraphMgt.VerifyIDInJson(JSON);
        LibraryGraphMgt.VerifyPropertyInJSON(JSON, 'number', LookupValue.Code);
        LibraryGraphMgt.VerifyPropertyInJSON(JSON, 'displayName', LookupValue.Description);
    end;
}