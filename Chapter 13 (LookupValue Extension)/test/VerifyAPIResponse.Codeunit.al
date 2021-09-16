codeunit 81070 "VerifyAPIResponse"
{
    Subtype = Test;

    [Test]
    procedure VerifyAPIResponse()
    begin
        VerifyProperties(ResponseTxt, 'GU00000000', 'GU00000001', 1);
        VerifyProperties(ResponseTxt, 'GU00000002', 'GU00000003', 2)
    end;

    local procedure VerifyProperties(ResponseText: Text; Value1: Text; Value2: Text; ObjectNumber: Integer)
    var
        LookupValueJSON: Text;
    begin
        LibraryGraphMgt.GetObjectFromJSONResponse(ResponseText, LookupValueJSON, ObjectNumber);
        Assert.AreNotEqual('', ResponseText, EmptyJSONErr);
        LibraryGraphMgt.VerifyIDInJson(LookupValueJSON);
        LibraryGraphMgt.VerifyPropertyInJSON(LookupValueJSON, 'number', Value1);
        LibraryGraphMgt.VerifyPropertyInJSON(LookupValueJSON, 'displayName', Value2);
    end;

    var
        Assert: Codeunit "Library Assert";
        LibraryGraphMgt: Codeunit "Library - Graph Mgt";
        // ResponseTxt: Label '{"@odata.context":"http://mpr-lpt-aw-38.mprise.group:7048/BC180/api/fluxxus/automation/v1.0/$metadata#companies(6c1b54a5-7d09-ec11-bb74-000d3a269838)/lookupValues","value":[{"@odata.etag":"W/"JzQ0O3lXZThKdEtSdXpZeHBwWHNXcHBpN2N2aVpLQjlYbitWSVdFVDhyQmhPcWc9MTswMDsn"","id":"66108f47-1116-ec11-ba8d-864a001babe0","number":"GU00000000","displayName":"GU00000001"}]}';

        ResponseTxt: Label '{"@odata.context":"http://mpr-lpt-aw-38.mprise.group:7048/BC180/api/fluxxus/automation/v1.0/$metadata#companies(6c1b54a5-7d09-ec11-bb74-000d3a269838)/lookupValues","value":[{"@odata.etag":"WJzQ0O3lXZThKdEtSdXpZeHBwWHNXcHBpN2N2aVpLQjlYbitWSVdFVDhyQmhPcWc9MTswMDsn","id":"66108f47-1116-ec11-ba8d-864a001babe0","number":"GU00000000","displayName":"GU00000001"},{"@odata.etag":"WJzQ0O3lXZThKdEtSdXpZeHBwWHNXcHBpN2N2aUpLQjlYbitWSVdFVDhyQmhPcWc9MTswMDsn","id":"67108f47-1116-ec11-ba8d-864a001babe0","number":"GU00000002","displayName":"GU00000003"}]}';

        EmptyJSONErr: Label 'JSON should not be empty.';

}