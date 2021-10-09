codeunit 60199 "InvalidVATLookupDataHndlMock"
// Mock of codeunit 60148 (abstract of codeunit 248 "VAT Lookup Ext. Data Hndl") returning an invalid log entry
{
    Permissions = TableData "VAT Registration Log" = rimd;
    TableNo = "VAT Registration Log";

    trigger OnRun()
    begin
        SetInvalidVATRegistrationLog(Rec);
    end;

    local procedure SetInvalidVATRegistrationLog(var VATRegistrationLog: Record "VAT Registration Log")
    var
        VATRegistrationLogMgt: Codeunit "VAT Registration Log Mgt. 1";
        InvalidVATResponseDoc: DotNet XmlDocument;
        NamespaceTxt: Label 'urn:ec.europa.eu:taxud:vies:services:checkVat:types', Locked = true;
    begin
        CreateInvalidVATCheckResponse(InvalidVATResponseDoc);
        VATRegistrationLogMgt.LogVerification(VATRegistrationLog, InvalidVATResponseDoc, NamespaceTxt);
    end;

    local procedure CreateInvalidVATCheckResponse(var XMLDoc: DotNet XmlDocument)
    var
        XMLDOMMgt: Codeunit "XML DOM Management";
        VATNode: DotNet XmlNode;
        InvalidNode: DotNet XmlNode;
        NamespaceTxt: Label 'urn:ec.europa.eu:taxud:vies:services:checkVat:types', Locked = true;
        VATTxt: Label 'vat', Locked = true;
        ValidTxt: Label 'valid', Locked = true;
    begin
        XMLDoc := XMLDoc.XmlDocument;
        XMLDOMMgt.AddRootElementWithPrefix(XMLDoc, VATTxt, '', NamespaceTxt, VATNode);
        XMLDOMMgt.AddElement(VATNode, ValidTxt, 'false', NamespaceTxt, InvalidNode);
    end;
}