pageextension 50016 "CustomerTemplateCardPageExt" extends "Customer Templ. Card" //1382
{
    layout
    {
        addlast(General)
        {
            field("Lookup Value Code"; Rec."Lookup Value Code")
            {
                ToolTip = 'Specifies the lookup value the customer buys from.';
                ApplicationArea = All;
            }
        }
    }
}