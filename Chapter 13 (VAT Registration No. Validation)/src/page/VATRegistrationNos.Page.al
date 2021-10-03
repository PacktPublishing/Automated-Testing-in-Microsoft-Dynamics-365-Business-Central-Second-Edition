page 60100 "VAT Registration Nos."
{
    ApplicationArea = All;
    Caption = 'VAT Registration Nos.';
    PageType = List;
    SourceTable = "VAT Registration No.";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field';
                    ApplicationArea = All;
                }
                field("Codeunit Set Method"; Rec."Codeunit Set Method")
                {
                    ToolTip = 'Specifies the value of the Codeunit Set Method field';
                    ApplicationArea = All;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ToolTip = 'Specifies the value of the Country/Region Code field';
                    ApplicationArea = All;
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ToolTip = 'Specifies the value of the VAT Registration No. field';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(VATRegistrationLog)
            {
                ApplicationArea = All;
                Caption = 'VAT Registration Log';
                Image = ImportLog;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "VAT Registration Log";
            }
        }
    }
}