pageextension 50014 "CustomerListPageExt" extends "Customer List" //22
{
    layout
    {
        addafter("No.")
        {
            field("Lookup Value Code"; Rec."Lookup Value Code")
            {
                ToolTip = 'Specifies the lookup value the customer buys from.';
                ApplicationArea = All;
            }
        }
    }
}