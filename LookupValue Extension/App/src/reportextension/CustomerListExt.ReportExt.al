reportextension 50000 "CustomerListExt" extends "Customer - List"
{
    RDLCLayout = './reportlayouts/CustomerListDefault.rdl';

    dataset
    {
        add(Customer)
        {
            column(Customer_Lookup_Value_Code; "Lookup Value Code")
            {
                IncludeCaption = true;
            }
        }
    }
}