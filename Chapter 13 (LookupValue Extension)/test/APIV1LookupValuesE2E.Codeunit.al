codeunit 81090 "APIV1 - LookupValues E2E"
{
    Subtype = Test;
    TestPermissions = Disabled;

    trigger OnRun()
    begin
        // [FEATURE] [Graph] [LookupValue]
    end;

    var
        Assert: Codeunit "Library Assert";
        LibraryGraphMgt: Codeunit "Library - Graph Mgt";
        LibraryUtility: Codeunit "Library - Utility";
        ServiceNameTxt: Label 'lookupValues';
        EmptyJSONErr: Label 'JSON should not be empty.';

    [Test]
    procedure TestGetLookupValue()
    var
        LookupValue: Record LookupValue;
        Response: Text;
        TargetURL: Text;
    begin
        // [SCENARIO xxxxx] User can get lookup value with GET request to service
        // [GIVEN] Lookup value
        CreateAndCommitLookupValue(LookupValue);

        // [WHEN] User makes GET request for given lookup value
        TargetURL := LibraryGraphMgt.CreateTargetURL(LookupValue.SystemId, Page::"APIV1 - Lookup Values", ServiceNameTxt);
        LibraryGraphMgt.GetFromWebService(Response, TargetURL);

        // [THEN] Response contains lookup value
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
        // [SCENARIO yyyyy] User can delete lookup value by making DELETE request.
        // [GIVEN] Lookup value
        CreateAndCommitLookupValue(LookupValue);
        LookupValueCode := LookupValue.Code;

        // [WHEN] User makes a DELETE request to endpoint for lookup value
        TargetURL := LibraryGraphMgt.CreateTargetURL(LookupValue.SystemId, Page::"APIV1 - Lookup Values", ServiceNameTxt);
        LibraryGraphMgt.DeleteFromWebService(TargetURL, '', Response);

        // [THEN] Response is empty
        Assert.AreEqual('', Response, 'DELETE response should be empty.');

        // [THEN] Lookup value is no longer in the database
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
        // [SCENARIO zzzzz] User can modify lookup value through PATCH request.
        // [GIVEN] Lookup value
        CreateAndCommitLookupValue(LookupValue);
        TempLookupValue.TransferFields(LookupValue);
        TempLookupValue.Description := LibraryUtility.GenerateGUID();
        RequestBody := GetLookupValueJSON(TempLookupValue);

        // [WHEN] User makes patch request to service
        TargetURL := LibraryGraphMgt.CreateTargetURL(LookupValue.SystemId, Page::"APIV1 - Lookup Values", ServiceNameTxt);
        LibraryGraphMgt.PatchToWebService(TargetURL, RequestBody, Response);

        // [THEN] Response text contains new value
        VerifyProperties(Response, TempLookupValue);

        // [THEN] Record in database contains new description
        LookupValue.Get(LookupValue.Code);
        VerifyProperties(Response, LookupValue);
    end;

    [Test]
    procedure TestCreateLookupValue()
    var
        LookupValue: Record LookupValue;
        TempLookupValue: Record LookupValue temporary;
        RequestBody: Text;
        Response: Text;
        TargetURL: Text;
    begin
        // [SCENARIO ttttt] User can create lookup value through POST request.
        // [GIVEN] Lookup value JSON object
        TempLookupValue.Code := LibraryUtility.GenerateGUID();
        TempLookupValue.Description := LibraryUtility.GenerateGUID();
        RequestBody := GetLookupValueJSON(TempLookupValue);

        // [WHEN] User makes POST request to service
        TargetURL := LibraryGraphMgt.CreateTargetURL('', Page::"APIV1 - Lookup Values", ServiceNameTxt);
        LibraryGraphMgt.PostToWebService(TargetURL, RequestBody, Response);

        // [THEN] Response text contains new lookup value
        VerifyProperties(Response, TempLookupValue);

        // [THEN] Lookup value created in database
        LookupValue.Get(TempLookupValue.Code);
        VerifyProperties(Response, LookupValue);
    end;

    local procedure CreateAndCommitLookupValue(var LookupValue: Record LookupValue)
    var
        LibraryLookupValue: Codeunit "Library - Lookup Value";
    begin
        LibraryLookupValue.CreateLookupValue(LookupValue);
        Commit(); // Need to commit in order to unlock tables and allow web service to pick up changes.
    end;

    local procedure GetLookupValueJSON(var LookupValue: Record LookupValue) LookupValueJson: Text
    begin
        LookupValueJson := LibraryGraphMgt.AddPropertytoJSON(LookupValueJson, 'number', LookupValue.Code);
        LookupValueJson := LibraryGraphMgt.AddPropertytoJSON(LookupValueJson, 'displayName', LookupValue.Description);
    end;

    local procedure VerifyProperties(JSON: Text; LookupValue: Record LookupValue)
    begin
        Assert.AreNotEqual('', JSON, EmptyJSONErr);
        LibraryGraphMgt.VerifyIDInJson(JSON);
        LibraryGraphMgt.VerifyPropertyInJSON(JSON, 'number', LookupValue.Code);
        LibraryGraphMgt.VerifyPropertyInJSON(JSON, 'displayName', LookupValue.Description);
    end;
}