tableextension 50005 "CustomerTemplTableExt" extends "Customer Templ." //5105
{
    fields
    {
        field(50000; "Lookup Value Code"; Code[10])
        {
            Caption = 'Lookup Value Code';
            DataClassification = ToBeClassified;
            TableRelation = "LookupValue";
        }
    }
}