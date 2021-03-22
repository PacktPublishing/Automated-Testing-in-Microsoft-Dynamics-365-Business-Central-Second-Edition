pageextension 70000 "Sales Invoice Subform Ext" extends "Sales Invoice Subform"
{
    layout
    {
        modify(Control39)
        {
            Visible = SubFrameVisible;
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SubFrameVisible := SetShowLinesSubFrame();
    end;

    local procedure SetShowLinesSubFrame() Result: Boolean
    var
        SalesHeader: Record "Sales Header";
        DocumentTypeFilter, DocumentNoFilter : Text;
    begin
        Rec.FilterGroup(2);
        DocumentTypeFilter := Rec.GetFilter("Document Type");
        if (DocumentTypeFilter <> '') and (Rec.GetRangeMin("Document Type") = Rec.GetRangeMax("Document Type")) then begin
            Rec.FilterGroup(4);
            DocumentNoFilter := Rec.GetFilter("Document No.");
            if (DocumentNoFilter <> '') and (Rec.GetRangeMin("Document No.") = Rec.GetRangeMax("Document No.")) then begin
                SalesHeader.Get(Rec."Document Type", Rec."Document No.");
                Result := SalesHeader."VAT Bus. Posting Group" <> 'EXPORT';
            end;
        end;
        Rec.FilterGroup(0);
    end;

    var
        SubFrameVisible: Boolean;
}