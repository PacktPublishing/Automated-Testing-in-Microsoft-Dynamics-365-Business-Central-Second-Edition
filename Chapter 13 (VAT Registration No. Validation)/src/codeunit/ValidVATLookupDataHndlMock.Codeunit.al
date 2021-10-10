codeunit 60198 "ValidVATLookupDataHndlMock"
// Mock of codeunit 60148 (abstract of codeunit 248 "VAT Lookup Ext. Data Hndl") returning a valid log entry
{
    Permissions = TableData "VAT Registration Log" = rimd;
    TableNo = "VAT Registration Log";

    trigger OnRun()
    begin
        SetValidVATRegistrationLog(Rec);

        Commit(); // To allow for details page to be triggered to open after this 
    end;

    local procedure SetValidVATRegistrationLog(var VATRegistrationLog: Record "VAT Registration Log")
    var
        Any: Codeunit Any;
        VATRegistrationLogMgt: Codeunit "VAT Reg. Log Mgt. Default";
        ValidVATResponseDoc: DotNet XmlDocument;
        ValidatedName: Text;
        ValidatedAddress: Text;
        NamespaceTxt: Label 'urn:ec.europa.eu:taxud:vies:services:checkVat:types', Locked = true;
    begin
        ValidatedName := Any.AlphanumericText(15);
        ValidatedAddress := Any.AlphanumericText(15);
        CreateValidVATCheckResponse(ValidVATResponseDoc, ValidatedName, ValidatedAddress);
        VATRegistrationLogMgt.LogVerification(VATRegistrationLog, ValidVATResponseDoc, NamespaceTxt);
    end;

    local procedure CreateValidVATCheckResponse(var XMLDoc: DotNet XmlDocument; ValidatedName: Text; ValidatedAddress: Text)
    var
        Any: Codeunit Any;
        XMLDOMMgt: Codeunit "XML DOM Management";
        VATNode: DotNet XmlNode;
        ValidNode: DotNet XmlNode;
        NamespaceTxt: Label 'urn:ec.europa.eu:taxud:vies:services:checkVat:types', Locked = true;
        AddressTxt: Label 'traderAddress', Locked = true;
        NameTxt: Label 'traderName', Locked = true;
        RequestIdTxt: Label 'requestIdentifier', Locked = true;
        VATTxt: Label 'vat', Locked = true;
        ValidTxt: Label 'valid', Locked = true;
    begin
        XMLDoc := XMLDoc.XmlDocument;
        XMLDOMMgt.AddRootElementWithPrefix(XMLDoc, VATTxt, '', NamespaceTxt, VATNode);
        XMLDOMMgt.AddElement(VATNode, RequestIdTxt, Any.AlphanumericText(15), NamespaceTxt, ValidNode);
        XMLDOMMgt.AddElement(VATNode, ValidTxt, 'true', NamespaceTxt, ValidNode);
        XMLDOMMgt.AddElement(VATNode, NameTxt, ValidatedName, NamespaceTxt, ValidNode);
        XMLDOMMgt.AddElement(VATNode, AddressTxt, ValidatedAddress, NamespaceTxt, ValidNode);
    end;
}