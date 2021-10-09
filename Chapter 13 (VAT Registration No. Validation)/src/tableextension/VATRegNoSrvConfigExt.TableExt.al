tableextension 60100 "VAT Reg. No. Srv Config Ext." extends "VAT Reg. No. Srv Config"
{
    fields
    {
        field(60100; "Handling Codeunit ID"; Integer)
        {
            Caption = 'Service Handling Codeunit ID';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Codeunit));
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Rec.CalcFields("Handling Codeunit Caption");
            end;
        }
        field(60101; "Handling Codeunit Caption"; Text[30])
        {
            Caption = 'Service Handling Codeunit Caption';
            FieldClass = FlowField;
            CalcFormula = lookup(AllObjWithCaption."Object Name" where("Object Type" = const(Codeunit), "Object ID" = field("Handling Codeunit ID")));
            Editable = false;
        }
    }
}