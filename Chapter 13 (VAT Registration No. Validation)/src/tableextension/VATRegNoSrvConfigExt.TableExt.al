tableextension 60100 "VAT Reg. No. Srv Config Ext." extends "VAT Reg. No. Srv Config"
{
    fields
    {
        field(60100; "Service Codeunit"; Integer)
        {
            Caption = 'Service Codeunit';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Codeunit));
            DataClassification = ToBeClassified;
        }
    }
}