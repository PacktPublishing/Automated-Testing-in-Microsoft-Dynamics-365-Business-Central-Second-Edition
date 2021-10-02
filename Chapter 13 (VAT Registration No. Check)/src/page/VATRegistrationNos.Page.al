page 60007 "VAT Registration Nos."
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
                    ApplicationArea = All;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
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