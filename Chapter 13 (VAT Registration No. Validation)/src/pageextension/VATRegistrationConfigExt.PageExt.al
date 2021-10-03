pageextension 60100 "VAT Registration Config Ext." extends "VAT Registration Config"
{
    layout
    {
        addlast(General)
        {
            field("VAT Reg. No. Srv Codeunit"; Rec."Service Codeunit")
            {
                ToolTip = 'Specifies the id of the codeunit that implements the interactio with the EU VAT Registration No. Validation Service.';
                ApplicationArea = All;
            }
        }
    }
}