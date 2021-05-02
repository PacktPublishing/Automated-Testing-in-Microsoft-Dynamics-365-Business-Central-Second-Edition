pageextension 50009 "SalesInvoiceListPageExt" extends "Sales Invoice List" //9301
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