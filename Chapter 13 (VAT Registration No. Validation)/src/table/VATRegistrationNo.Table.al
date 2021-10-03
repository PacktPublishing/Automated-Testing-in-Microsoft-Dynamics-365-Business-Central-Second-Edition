table 60100 "VAT Registration No."
{
    DataClassification = ToBeClassified;
    Caption = 'VAT Registration Nos.';

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'No.';
            NotBlank = true;
        }
        field(35; "Country/Region Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";

            trigger OnValidate()
            begin
                if "Country/Region Code" <> xRec."Country/Region Code" then
                    VATRegistrationValidationSelector();
            end;
        }
        field(86; "VAT Registration No."; Text[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'VAT Registration No.';

            trigger OnValidate()
            begin
                "VAT Registration No." := UpperCase("VAT Registration No.");
                if "VAT Registration No." <> xRec."VAT Registration No." then
                    VATRegistrationValidationSelector();
            end;
        }
        field(60100; "Codeunit Set Method"; Enum "Codeunit Set Method")
        {
            DataClassification = ToBeClassified;
            Caption = 'Codeunit Set Method';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    local procedure VATRegistrationValidationSelector()
    var
        VATRegNoSrvConfig: Record "VAT Reg. No. Srv Config";
        VATRegLogMgtEvents: Codeunit "VAT Reg. Log Mgt. Events";
    begin
        case "Codeunit Set Method" of
            "Codeunit Set Method"::"Default Codeunit":
                VATRegistrationValidation1();
            "Codeunit Set Method"::"From Setup":
                begin
                    VATRegNoSrvConfig.Get();
                    VATRegNoSrvConfig.TestField("Service Codeunit");
                    VATRegistrationValidation2("No.", "VAT Registration No.", "Country/Region Code", VATRegNoSrvConfig."Service Codeunit");
                end;
            "Codeunit Set Method"::"Set with Subscriber":
                begin
                    BindSubscription(VATRegLogMgtEvents);
                    VATRegistrationValidation2("No.", "VAT Registration No.", "Country/Region Code", 0);
                    UnbindSubscription(VATRegLogMgtEvents);
                end;
            "Codeunit Set Method"::"Set with Interface":
                ;
        end;
    end;

    procedure VATRegistrationValidation1()
    var
        VATRegistrationNoFormat: Record "VAT Registration No. Format";
        VATRegistrationLog: Record "VAT Registration Log";
        VATRegNoSrvConfig: Record "VAT Reg. No. Srv Config";
        VATRegistrationLogMgt: Codeunit "VAT Registration Log Mgt. 1";
        ResultRecordRef: RecordRef;
        ApplicableCountryCode: Code[10];
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeVATRegistrationValidation(Rec, IsHandled);
        if IsHandled then
            exit;

        if not VATRegistrationNoFormat.Test("VAT Registration No.", "Country/Region Code", "No.", DATABASE::"VAT Registration No.") then
            exit;

        if ("Country/Region Code" <> '') or (VATRegistrationNoFormat."Country/Region Code" <> '') then begin
            ApplicableCountryCode := "Country/Region Code";
            if ApplicableCountryCode = '' then
                ApplicableCountryCode := VATRegistrationNoFormat."Country/Region Code";
            if VATRegNoSrvConfig.VATRegNoSrvIsEnabled then begin
                VATRegistrationLogMgt.ValidateVATRegNoWithVIES(
                    ResultRecordRef, Rec, "No.", VATRegistrationLog."Account Type"::Customer.AsInteger(), ApplicableCountryCode);
                ResultRecordRef.SetTable(Rec);
            end;
        end;
    end;

    procedure VATRegistrationValidation2(EntryNo: Code[20]; VATRegNo: Text[20]; CountryCode: Code[10]; VATRegNoSrvCodeunitId: Integer)
    var
        VATRegistrationNoFormat: Record "VAT Registration No. Format";
        VATRegistrationLog: Record "VAT Registration Log";
        VATRegNoSrvConfig: Record "VAT Reg. No. Srv Config";
        VATRegistrationLogMgt: Codeunit "VAT Registration Log Mgt. 2";
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