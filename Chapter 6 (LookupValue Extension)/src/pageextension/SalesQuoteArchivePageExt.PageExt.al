pageextension 50042 "SalesQuoteArchivePageExt" extends "Sales Quote Archive" //5162
{
    layout
    {
        addlast(General)
        {
            field("Lookup Value Code"; Rec."Lookup Value Code")
            {
                ToolTip = 'Specifies the lookup value the transaction is done for.';
                ApplicationArea = All;
            }
        }
    }
}