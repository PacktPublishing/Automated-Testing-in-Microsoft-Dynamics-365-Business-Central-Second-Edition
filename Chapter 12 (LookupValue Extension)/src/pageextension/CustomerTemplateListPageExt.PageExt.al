pageextension 50015 "CustomerTemplateListPageExt" extends "Customer Templ. List" //1381
{
    layout
    {
        addafter(Code)
        {
            field("Lookup Value Code"; Rec."Lookup Value Code")
            {
                ToolTip = 'Specifies the lookup value the customer buys from.';
                ApplicationArea = All;
            }
        }
    }
}