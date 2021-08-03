pageextension 50044 "SalesRtrnOrderListArchPageExt" extends "Sales Return List Archive" //6629
{
    layout
    {
        addafter("No.")
        {
            field("Lookup Value Code"; Rec."Lookup Value Code")
            {
                ToolTip = 'Specifies the lookup value the transaction is done for.';
                ApplicationArea = All;
            }
        }
    }
}