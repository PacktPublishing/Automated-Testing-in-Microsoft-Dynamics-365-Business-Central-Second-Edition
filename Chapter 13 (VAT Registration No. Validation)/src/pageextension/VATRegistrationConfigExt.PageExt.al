pageextension 60100 "VAT Registration Config Ext." extends "VAT Registration Config"
{
    layout
    {
        addlast(General)
        {
            field("Handling Codeunit ID"; Rec."Handling Codeunit ID")
            {
                ToolTip = 'Specifies the id of the codeunit that implements the interaction with the EU VAT Registration No. Validation Service.';
                ApplicationArea = All;
            }
            field("Handling Codeunit Name"; Rec."Handling Codeunit Caption")
            {
                ToolTip = 'Specifies the name of the codeunit that implements the interaction with the EU VAT Registration No. Validation Service.';
                ApplicationArea = All;
            }
        }
    }
}