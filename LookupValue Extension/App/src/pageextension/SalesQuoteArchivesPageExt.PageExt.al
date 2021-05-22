pageextension 50045 "SalesQuoteArchivesPageExt" extends "Sales Quote Archives" //9348
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