codeunit 81090 "LookupValue API"
{
    Subtype = Test;
    TestPermissions = Disabled;

    trigger OnRun()
    begin
        // [FEATURE] LookupValue UT API
    end;

    var
        Assert: Codeunit "Library Assert";
        LibraryGraphMgt: Codeunit "Library - Graph Mgt";
        LibraryUtility: Codeunit "Library - Utility";

    [Test]
    procedure GetLookupValue()
    // [FEATURE] LookupValue UT API
    var
        LookupValue: Record LookupValue;
        Response: Text;
    begin
        // [SCENARIO #0200] Get lookup value

        // [GIVEN] Committed lookup value
        CreateCommittedLookupValue(LookupValue);

        // [WHEN] Send GET request for lookup value
        Response := SendGetRequestForLookupValue(LookupValue);

        // [THEN] Lookup value in response
        VerifyLookupValueInResponse(Response, LookupValue);
    end;

    [Test]
    procedure DeleteLookupValue()
    // [FEATURE] LookupValue UT API
    var
        LookupValue: Record LookupValue;
        Response: Text;
    begin
        // [SCENARIO #0201] Delete lookup value

        // [GIVEN] Committed lookup value
        CreateCommittedLookupValue(LookupValue);

        // [WHEN] Send DELETE request for lookup value
        Response := SendDeleteRequestForLookupValue(LookupValue);

        // [THEN] Empty response
        VerifyEmptyResponse(Response);
        // [THEN] Lookup value deleted from database
        VerifyLookupValueDeletedFromDatabase(LookupValue.Code);
    end;

    [Test]
    procedure ModifyLookupValue()
    // [FEATURE] LookupValue UT API
    var
        LookupValue: Record LookupValue;
        TempLookupValue: Record LookupValue temporary;
        RequestBody: Text;
        Response: Text;
    begin
        // [SCENARIO #0202] Modify lookup value

        // [GIVEN] Committed lookup value
        CreateCommittedLookupValue(LookupValue);
        // [GIVEN] Updated lookup value JSON object
        TempLookupValue.Code := LookupValue.Code;
        TempLookupValue.Description := LibraryUtility.GenerateRandomText(MaxStrLen(TempLookupValue.Description));
        RequestBody := GetLookupValueJSON(TempLookupValue);

        // [WHEN] Send PATCH request for lookup value JSON object
        Response := SendPatchRequestForLookupValueJSONObject(LookupValue, RequestBody);

        // [THEN] Updated lookup value in response
        VerifyLookupValueInResponse(Response, TempLookupValue);
        // [THEN] Updated lookup value in database
        LookupValue.Get(LookupValue.Code);
        VerifyLookupValueInResponse(Response, LookupValue);
    end;

    [Test]
    procedure CreateLookupValue()
    // [FEATURE] LookupValue UT API
    var
        LookupValue: Record LookupValue;
        TempLookupValue: Record LookupValue temporary;
        RequestBody: Text;
        Response: Text;
    begin
        // [SCENARIO #0203] Create lookup value

        // [GIVEN] Lookup value JSON object
        TempLookupValue.Code := LibraryUtility.GenerateRandomCode(TempLookupValue.FieldNo(Code), Database::LookupValue);
        TempLookupValue.Description := TempLookupValue.Code;
        RequestBody := GetLookupValueJSON(TempLookupValue);

        // [WHEN] Send POST request for lookup value JSON object
        Response := SendPostRequestForLookupValueJSONObject(RequestBody);

        // [THEN] New lookup value in response
        VerifyLookupValueInResponse(Response, TempLookupValue);
        // [THEN] New lookup value in database
        LookupValue.Get(TempLookupValue.Code);
        VerifyLookupValueInResponse(Response, LookupValue);
    end;

    local procedure CreateCommittedLookupValue(var LookupValue: Record LookupValue)
    var
        LibraryLookupValue: Codeunit "Library - Lookup Value";
    begin
        LibraryLookupValue.CreateLookupValue(LookupValue);
        Commit(); // Need to commit in order to unlock tables and allow web service to pick up changes.
    end;

    local procedure GetLookupValueJSON(var LookupValue: Record LookupValue) LookupValueJSON: Text
    begin
        LookupValueJSON := LibraryGraphMgt.AddPropertytoJSON(LookupValueJSON, 'number', LookupValue.Code);
        LookupValueJSON := LibraryGraphMgt.AddPropertytoJSON(LookupValueJSON, 'displayName', LookupValue.Description);
    end;

    local procedure SendDeleteRequestForLookupValue(LookupValue: Record LookupValue) Response: Text
    begin
        LibraryGraphMgt.DeleteFromWebService(CreateTargetURL(LookupValue.SystemId), '', Response);
    end;

    local procedure SendGetRequestForLookupValue(LookupValue: Record LookupValue) Response: Text
    begin
        LibraryGraphMgt.GetFromWebService(Response, CreateTargetURL(LookupValue.SystemId));
    end;

    local procedure SendPatchRequestForLookupValueJSONObject(LookupValue: Record LookupValue; RequestBody: Text) Response: Text
    begin
        LibraryGraphMgt.PatchToWebService(CreateTargetURL(LookupValue.SystemId), RequestBody, Response);
    end;

    local procedure SendPostRequestForLookupValueJSONObject(RequestBody: Text) Response: Text
    begin
        LibraryGraphMgt.PostToWebService(CreateTargetURL(''), RequestBody, Response);
    end;

    local procedure CreateTargetURL(ID: Text): Text
    begin
        exit(LibraryGraphMgt.CreateTargetURL(ID, Page::"APIV1 - Lookup Values", 'lookupValues'));
    end;

    local procedure VerifyEmptyResponse(Response: Text)
    begin
        Assert.AreEqual('', Response, 'DELETE response should be empty.');
    end;

    local procedure VerifyLookupValueDeletedFromDatabase(LookupValueCode: Code[10])
    var
        LookupValue: Record LookupValue;
    begin
        LookupValue.SetRange(Code, LookupValueCode);
        Assert.IsTrue(LookupValue.IsEmpty(), 'Lookup Value should be deleted.');
    end;

    local procedure VerifyLookupValueInResponse(JSON: Text; LookupValue: Record LookupValue)
    begin
        Assert.AreNotEqual('', JSON, 'JSON should not be empty.');
        LibraryGraphMgt.VerifyIDInJson(JSON);
        LibraryGraphMgt.VerifyPropertyInJSON(JSON, 'number', LookupValue.Code);
        LibraryGraphMgt.VerifyPropertyInJSON(JSON, 'displayName', LookupValue.Description);
    end;
}