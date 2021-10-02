codeunit 60049 "VAT Registration Log Mgt. FLX"
// abstract of codeunit 249 "VAT Registration Log Mgt."
{
    Permissions = TableData "VAT Registration Log" = rimd;

    var
        DataTypeManagement: Codeunit "Data Type Management";

    procedure ValidateVATRegNoWithVIES(var RecordRef: RecordRef; RecordVariant: Variant; EntryNo: Code[20]; AccountType: Option; CountryCode: Code[10]; VATRegNoSrvCodeunitId: Integer)
    var
        VATRegistrationLog: Record "VAT Registration Log";
    begin
        CheckVIESForVATNo(RecordRef, VATRegistrationLog, RecordVariant, EntryNo, CountryCode, AccountType, VATRegNoSrvCodeunitId);
    end;

    procedure CheckVIESForVATNo(var RecordRef: RecordRef; var VATRegistrationLog: Record "VAT Registration Log"; RecordVariant: Variant; EntryNo: Code[20]; CountryCode: Code[10]; AccountType: Option; VATRegNoSrvCodeunitId: Integer)
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
            Codeunit.Run(VATRegNoSrvCodeunitId, VATRegistrationLog);
        end;
    end;
}