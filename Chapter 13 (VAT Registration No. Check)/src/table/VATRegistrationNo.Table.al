table 60008 "VAT Registration No."
{
    DataClassification = ToBeClassified;
    Caption = 'VAT Registration Nos.';

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
        }
        field(35; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";

            trigger OnValidate()
            begin
                if "Country/Region Code" <> xRec."Country/Region Code" then
                    VATRegistrationValidation();
            end;
        }
        field(86; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';

            trigger OnValidate()
            begin
                "VAT Registration No." := UpperCase("VAT Registration No.");
                if "VAT Registration No." <> xRec."VAT Registration No." then
                    VATRegistrationValidation();
            end;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    local procedure VATRegistrationValidation()
    begin
        VATRegistrationValidation("No.", "VAT Registration No.", "Country/Region Code", CODEUNIT::"VAT Lookup Ext. Data Hndl FLX");
    end;

    procedure VATRegistrationValidation(EntryNo: Code[20]; VATRegNo: Text[20]; CountryCode: Code[10]; VATRegNoSrvCodeunitId: Integer)
    var
        VATRegistrationNoFormat: Record "VAT Registration No. Format";
        VATRegistrationLog: Record "VAT Registration Log";
        VATRegNoSrvConfig: Record "VAT Reg. No. Srv Config";
        VATRegistrationLogMgt: Codeunit "VAT Registration Log Mgt. FLX";
        ResultRecordRef: RecordRef;
        ApplicableCountryCode: Code[10];
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeVATRegistrationValidation(Rec, IsHandled);
        if IsHandled then
            exit;

        if not VATRegistrationNoFormat.Test(VATRegNo, CountryCode, "No.", DATABASE::"VAT Registration No.") then
            exit;

        if (CountryCode <> '') or (VATRegistrationNoFormat."Country/Region Code" <> '') then begin
            ApplicableCountryCode := CountryCode;
            if ApplicableCountryCode = '' then
                ApplicableCountryCode := VATRegistrationNoFormat."Country/Region Code";
            if VATRegNoSrvConfig.VATRegNoSrvIsEnabled then begin
                VATRegistrationLogMgt.ValidateVATRegNoWithVIES(
                    ResultRecordRef, Rec, "No.", VATRegistrationLog."Account Type"::Customer.AsInteger(), ApplicableCountryCode, VATRegNoSrvCodeunitId);
                ResultRecordRef.SetTable(Rec);
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeVATRegistrationValidation(var VATRegNo: Record "VAT Registration No."; var IsHandled: Boolean)
    begin
    end;
}