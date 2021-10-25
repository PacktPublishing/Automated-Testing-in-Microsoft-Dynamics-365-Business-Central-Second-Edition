codeunit 81090 "LookupValue APIV1"
{
    // Generated on 27-9-2021 at 15:21 by lvanvugt

    Subtype = Test;

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
        RequestBody := CreateUpdatedLookupValueJSONObject(LookupValue.Code, TempLookupValue);

        // [WHEN] Send PATCH request for lookup value JSON object
        Response := SendPatchRequestForLookupValue(LookupValue, RequestBody);

        // [THEN] Updated lookup value in response
        VerifyLookupValueInResponse(Response, TempLookupValue);
        // [THEN] Updated lookup value in database
        VerifyLookupValueInDatabase(LookupValue.Code, Response);
    end;

    [Test]
    procedure ModifyLookupValueWithEmptyDescription()
    // [FEATURE] LookupValue UT API
    var
        LookupValue: Record LookupValue;
        TempLookupValue: Record LookupValue temporary;
        RequestBody: Text;
        Response: Text;
    begin
        // [SCENARIO #0204] Modify lookup value with empty description

        // [GIVEN] Committed lookup value
        CreateCommittedLookupValue(LookupValue);
        // [GIVEN] Updated lookup value JSON object with empty description
        RequestBody := CreateUpdatedLookupValueJSONObjectWithEmptyDescription(LookupValue.Code, TempLookupValue);

        // [WHEN] Send PATCH request for lookup value JSON object
        asserterror Response := SendPatchRequestForLookupValue(LookupValue, RequestBody);

        // [THEN] Empty response
        VerifyEmptyResponse(Response);
        // [THEN] Non-updated lookup value in database
        VerifyNonUpdatedLookupValueInDatabase(LookupValue);
    end;

    [Test]
    procedure CreateLookupValue()
    // [FEATURE] LookupValue UT API
    var
        TempLookupValue: Record LookupValue temporary;
        RequestBody: Text;
        Response: Text;
    begin
        // [SCENARIO #0203] Create lookup value

        // [GIVEN] Lookup value JSON object
        RequestBody := CreateLookupValueJSONObject(TempLookupValue);

        // [WHEN] Send POST request for lookup value JSON object
        Response := SendPostRequestForLookupValue(RequestBody);

        // [THEN] New lookup value in response
        VerifyLookupValueInResponse(Response, TempLookupValue);
        // [THEN] New lookup value in database
        VerifyLookupValueInDatabase(TempLookupValue.Code, Response);
    end;

    [Test]
    procedure CreateLookupValueWithEmptyDescription()
    // [FEATURE] LookupValue UT API
    var
        TempLookupValue: Record LookupValue temporary;
        RequestBody: Text;
        Response: Text;
    begin
        // [SCENARIO #0205] Create lookup value with empty description

        // [GIVEN] Lookup value JSON object with empty description
        RequestBody := CreateLookupValueJSONObjectWithEmptyDescription(TempLookupValue);

        // [WHEN] Send POST request for lookup value JSON object
        asserterror Response := SendPostRequestForLookupValue(RequestBody);

        // [THEN] Empty response
        VerifyEmptyResponse(Response);
        // [THEN] No new lookup value in database
        VerifyNoNewLookupValueInDatabase(TempLookupValue);
    end;

    local procedure CreateCommittedLookupValue(var LookupValue: Record LookupValue)
    var
        LibraryLookupValue: Codeunit "Library - Lookup Value";
    begin
        LibraryLookupValue.CreateLookupValue(LookupValue);
        Commit(); // Need to commit in order to unlock tables and allow web service to pick up changes.
    end;

    local procedure CreateUpdatedLookupValueJSONObject(LookupValueCode: Code[10]; var TempLookupValue: Record LookupValue temporary): Text
    begin
        TempLookupValue.Code := LookupValueCode;
        exit(GetLookupValueJSONObject(TempLookupValue.Code, TempLookupValue.Code, TempLookupValue));
    end;

    local procedure CreateUpdatedLookupValueJSONObjectWithEmptyDescription(LookupValueCode: Code[10]; var TempLookupValue: Record LookupValue temporary): Text
    begin
        TempLookupValue.Code := LookupValueCode;
        exit(GetLookupValueJSONObject(TempLookupValue.Code, '', TempLookupValue));
    end;

    local procedure CreateLookupValueJSONObject(var TempLookupValue: Record LookupValue temporary): Text
    begin
        TempLookupValue.Code := LibraryUtility.GenerateRandomCode(TempLookupValue.FieldNo(Code), Database::LookupValue);
        exit(GetLookupValueJSONObject(TempLookupValue.Code, TempLookupValue.Code, TempLookupValue));
    end;

    local procedure CreateLookupValueJSONObjectWithEmptyDescription(var TempLookupValue: Record LookupValue temporary): Text
    begin
        TempLookupValue.Code := LibraryUtility.GenerateRandomCode(TempLookupValue.FieldNo(Code), Database::LookupValue);
        exit(GetLookupValueJSONObject(TempLookupValue.Code, '', TempLookupValue));
    end;

    local procedure GetLookupValueJSONObject(NewCode: Code[10]; NewDescription: Text[50]; var TempLookupValue: Record LookupValue temporary) LookupValueJSON: Text
    begin
        TempLookupValue.Code := NewCode;
        TempLookupValue.Description := NewDescription;
        LookupValueJSON := LibraryGraphMgt.AddPropertytoJSON(LookupValueJSON, 'number', NewCode);
        LookupValueJSON := LibraryGraphMgt.AddPropertytoJSON(LookupValueJSON, 'displayName', NewDescription);
    end;

    local procedure SendDeleteRequestForLookupValue(LookupValue: Record LookupValue) Response: Text
    begin
        LibraryGraphMgt.DeleteFromWebService(CreateTargetURL(LookupValue.SystemId), '', Response);
    end;

    local procedure SendGetRequestForLookupValue(LookupValue: Record LookupValue) Response: Text
    begin
        LibraryGraphMgt.GetFromWebService(Response, CreateTargetURL(LookupValue.SystemId));
    end;

    local procedure SendPatchRequestForLookupValue(LookupValue: Record LookupValue; RequestBody: Text) Response: Text
    begin
        LibraryGraphMgt.PatchToWebService(CreateTargetURL(LookupValue.SystemId), RequestBody, Response);
    end;

    local procedure SendPostRequestForLookupValue(RequestBody: Text) Response: Text
    begin
        LibraryGraphMgt.PostToWebService(CreateTargetURL(''), RequestBody, Response);
    end;

    local procedure CreateTargetURL(ID: Text): Text
    begin
        exit(LibraryGraphMgt.CreateTargetURL(ID, Page::"Lookup Values APIV1", 'lookupValues'));
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

    local procedure VerifyLookupValueInDatabase(LookupValueCode: Code[10]; Response: Text)
    var
        LookupValue: Record LookupValue;
    begin
        LookupValue.Get(LookupValueCode);
        VerifyLookupValueInResponse(Response, LookupValue);
    end;

    local procedure VerifyNonUpdatedLookupValueInDatabase(LookupValue: Record LookupValue)
    var
        LookupValue2: Record LookupValue;
    begin
        LookupValue2.Get(LookupValue.Code);
        Assert.AreEqual(LookupValue.Description, LookupValue2.Description, 'Lookup value should not be updated in database.');
    end;

    local procedure VerifyNoNewLookupValueInDatabase(LookupValue: Record LookupValue)
    begin
        LookupValue.SetRange(Code, LookupValue.Code);
        Assert.RecordIsEmpty(LookupValue);
    end;
}