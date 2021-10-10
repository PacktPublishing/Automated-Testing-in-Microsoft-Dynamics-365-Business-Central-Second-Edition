codeunit 60149 "VAT Reg. Log Mgt. Default"
// abstracted from codeunit 249 "VAT Registration Log Mgt."
{
    Permissions = TableData "VAT Registration Log" = rimd;

    var
        ValidPathTxt: Label 'descendant::vat:valid', Locked = true;
        NamePathTxt: Label 'descendant::vat:traderName', Locked = true;
        AddressPathTxt: Label 'descendant::vat:traderAddress', Locked = true;
        RequestIdPathTxt: Label 'descendant::vat:requestIdentifier', Locked = true;
        PostcodePathTxt: Label 'descendant::vat:traderPostcode', Locked = true;
        StreetPathTxt: Label 'descendant::vat:traderStreet', Locked = true;
        CityPathTxt: Label 'descendant::vat:traderCity', Locked = true;
        DataTypeManagement: Codeunit "Data Type Management";
        ValidVATNoMsg: Label 'The specified VAT registration number is valid.';
        InvalidVatRegNoMsg: Label 'We didn''t find a match for this VAT registration number. Please verify that you specified the right number.';
        NotVerifiedVATRegMsg: Label 'We couldn''t verify the VAT registration number. Please try again later.';
        UnexpectedResponseErr: Label 'The VAT registration number could not be verified because the VIES VAT Registration No. service may be currently unavailable for the selected EU state, %1.', Comment = '%1 - Country / Region Code';
        EUVATRegNoValidationServiceTok: Label 'EUVATRegNoValidationServiceTelemetryCategoryTok', Locked = true;
        ValidationFailureMsg: Label 'VIES service may be currently unavailable', Locked = true;
        NameMatchPathTxt: Label 'descendant::vat:traderNameMatch', Locked = true;
        StreetMatchPathTxt: Label 'descendant::vat:traderStreetMatch', Locked = true;
        PostcodeMatchPathTxt: Label 'descendant::vat:traderPostcodeMatch', Locked = true;
        CityMatchPathTxt: Label 'descendant::vat:traderCityMatch', Locked = true;
        DetailsNotVerifiedMsg: Label 'The specified VAT registration number is valid.\The VAT VIES validation service did not provide additional details.';

    [Scope('OnPrem')]
    procedure LogVerification(var VATRegistrationLog: Record "VAT Registration Log"; XMLDoc: DotNet XmlDocument; Namespace: Text)
    var
        XMLDOMMgt: Codeunit "XML DOM Management";
        FoundXmlNode: DotNet XmlNode;
        ResponsedName: Text;
        ResponsedPostCode: Text;
        ResponsedCity: Text;
        ResponsedStreet: Text;
        ResponsedAddress: Text;
        MatchName: Boolean;
        MatchStreet: Boolean;
        MatchPostCode: Boolean;
        MatchCity: Boolean;
    begin
        if not XMLDOMMgt.FindNodeWithNamespace(XMLDoc.DocumentElement, ValidPathTxt, 'vat', Namespace, FoundXmlNode) then begin
            Session.LogMessage('0000C4T', ValidationFailureMsg, Verbosity::Error, DataClassification::SystemMetadata, TelemetryScope::ExtensionPublisher, 'Category', EUVATRegNoValidationServiceTok);
            Error(UnexpectedResponseErr, VATRegistrationLog."Country/Region Code");
        end;

        case LowerCase(FoundXmlNode.InnerText) of
            'true':
                begin
                    VATRegistrationLog."Entry No." := 0;
                    VATRegistrationLog.Status := VATRegistrationLog.Status::Valid;
                    VATRegistrationLog."Verified Date" := CurrentDateTime;
                    VATRegistrationLog."User ID" := UserId;

                    VATRegistrationLog."Request Identifier" := CopyStr(ExtractValue(RequestIdPathTxt, XMLDoc, Namespace), 1,
                        MaxStrLen(VATRegistrationLog."Request Identifier"));

                    ResponsedName := ExtractValue(NamePathTxt, XMLDoc, Namespace);
                    ResponsedAddress := ExtractValue(AddressPathTxt, XMLDoc, Namespace);
                    ResponsedStreet := ExtractValue(StreetPathTxt, XMLDoc, Namespace);
                    ResponsedPostCode := ExtractValue(PostcodePathTxt, XMLDoc, Namespace);
                    ResponsedCity := ExtractValue(CityPathTxt, XMLDoc, Namespace);
                    VATRegistrationLog.SetResponseDetails(
                      ResponsedName, ResponsedAddress, ResponsedStreet, ResponsedCity, ResponsedPostCode);

                    MatchName := ExtractValue(NameMatchPathTxt, XMLDoc, Namespace) = '1';
                    MatchStreet := ExtractValue(StreetMatchPathTxt, XMLDoc, Namespace) = '1';
                    MatchPostCode := ExtractValue(PostcodeMatchPathTxt, XMLDoc, Namespace) = '1';
                    MatchCity := ExtractValue(CityMatchPathTxt, XMLDoc, Namespace) = '1';
                    VATRegistrationLog.SetResponseMatchDetails(MatchName, MatchStreet, MatchCity, MatchPostCode);

                    VATRegistrationLog.Insert(true);

                    if VATRegistrationLog.LogDetails() then
                        VATRegistrationLog.Modify();
                end;
            'false':
                begin
                    VATRegistrationLog."Entry No." := 0;
                    VATRegistrationLog."Verified Date" := CurrentDateTime;
                    VATRegistrationLog.Status := VATRegistrationLog.Status::Invalid;
                    VATRegistrationLog."User ID" := UserId;
                    VATRegistrationLog."Verified Name" := '';
                    VATRegistrationLog."Verified Address" := '';
                    VATRegistrationLog."Request Identifier" := '';
                    VATRegistrationLog."Verified Postcode" := '';
                    VATRegistrationLog."Verified Street" := '';
                    VATRegistrationLog."Verified City" := '';
                    VATRegistrationLog.Insert(true);
                end;
        end;
    end;

    procedure ValidateVATRegNoWithVIES(var RecordRef: RecordRef; RecordVariant: Variant; EntryNo: Code[20]; AccountType: Option; CountryCode: Code[10])
    var
        VATRegistrationLog: Record "VAT Registration Log";
    begin
        CheckVIESForVATNo(RecordRef, VATRegistrationLog, RecordVariant, EntryNo, CountryCode, AccountType);

        if VATRegistrationLog.Find() then // Only update if the log was created
            UpdateRecordFromVATRegLog(RecordRef, RecordVariant, VATRegistrationLog);
    end;

    local procedure ExtractValue(Xpath: Text; XMLDoc: DotNet XmlDocument; Namespace: Text): Text
    var
        XMLDOMMgt: Codeunit "XML DOM Management";
        FoundXmlNode: DotNet XmlNode;
    begin
        if not XMLDOMMgt.FindNodeWithNamespace(XMLDoc.DocumentElement, Xpath, 'vat', Namespace, FoundXmlNode) then
            exit('');
        exit(FoundXmlNode.InnerText);
    end;

    procedure CheckVIESForVATNo(var RecordRef: RecordRef; var VATRegistrationLog: Record "VAT Registration Log"; RecordVariant: Variant; EntryNo: Code[20]; CountryCode: Code[10]; AccountType: Option)
    var
        VATRegNo: Record "VAT Registration No.";
        VATRegNoSrvConfig: Record "VAT Reg. No. Srv Config";
        CountryRegion: Record "Country/Region";
        VatRegNoFieldRef: FieldRef;
        VATRegNoTxt: Text[20];
    begin
        RecordRef.GetTable(RecordVariant);
        if not CountryRegion.IsEUCountry(CountryCode) then
            exit; // VAT Reg. check Srv. is only available for EU countries.

        if VATRegNoSrvConfig.VATRegNoSrvIsEnabled() then begin
            DataTypeManagement.GetRecordRef(RecordVariant, RecordRef);
            if not DataTypeManagement.FindFieldByName(RecordRef, VatRegNoFieldRef, VATRegNo.FieldName("VAT Registration No.")) then
                exit;
            VATRegNoTxt := VatRegNoFieldRef.Value;

            VATRegistrationLog.InitVATRegLog(VATRegistrationLog, CountryCode, AccountType, EntryNo, VATRegNoTxt);
            Codeunit.Run(CODEUNIT::"VATLookupExtDataHndlDefault", VATRegistrationLog);
        end;
    end;

    procedure UpdateRecordFromVATRegLog(var RecordRef: RecordRef; RecordVariant: Variant; VATRegistrationLog: Record "VAT Registration Log")
    begin
        if GuiAllowed() then begin
            RecordRef.GetTable(RecordVariant);
            case VATRegistrationLog.Status of
                VATRegistrationLog.Status::Valid:
                    case VATRegistrationLog."Details Status" of
                        VATRegistrationLog."Details Status"::"Not Verified":
                            Message(DetailsNotVerifiedMsg);
                        VATRegistrationLog."Details Status"::Valid:
                            Message(ValidVATNoMsg);
                        VATRegistrationLog."Details Status"::"Partially Valid",
                        VATRegistrationLog."Details Status"::"Not Valid":
                            begin
                                DataTypeManagement.GetRecordRef(RecordVariant, RecordRef);
                                VATRegistrationLog.OpenDetailsForRecRef(RecordRef);
                            end;
                    end;
                VATRegistrationLog.Status::Invalid:
                    Message(InvalidVatRegNoMsg);
                else
                    Message(NotVerifiedVATRegMsg);
            end;
        end;
    end;
}