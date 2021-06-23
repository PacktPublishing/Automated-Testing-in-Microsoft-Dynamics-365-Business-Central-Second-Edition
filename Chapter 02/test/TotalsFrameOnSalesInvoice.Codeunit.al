codeunit 70000 "TotalsFrameOnSalesInvoice"
{
    Subtype = Test;

    [Test]
    procedure Test1()
    var
        SalesHeader: Record "Sales Header";
    begin
        CreateSalesInvoice(SalesHeader, 'EXPORT');
        OpenSalesInvoicePageAndVerifyVisibility(SalesHeader, false);
    end;

    [Test]
    procedure Test2()
    var
        SalesHeader: Record "Sales Header";
    begin
        CreateSalesInvoice(SalesHeader, 'DOMESTIC');
        OpenSalesInvoicePageAndVerifyVisibility(SalesHeader, true);
    end;

    local procedure CreateSalesInvoice(var SalesHeader: Record "Sales Header"; VATBusPostingGroup: Code[20])
    begin
        SalesHeader."Document Type" := "Sales Document Type"::Invoice;
        SalesHeader.Insert(true);
        SalesHeader.Validate("VAT Bus. Posting Group", VATBusPostingGroup);
        SalesHeader.Modify();
    end;

    local procedure OpenSalesInvoicePageAndVerifyVisibility(SalesHeader: Record "Sales Header"; FrameVisible: Boolean)
    var
        SalesInvoice: TestPage "Sales Invoice";
    begin
        SalesInvoice.OpenView();
        SalesInvoice.GoToRecord(SalesHeader);
        case FrameVisible of
            true:
                if not SalesInvoice.SalesLines."Total Amount Excl. VAT".Visible() then
                    Error('%1 should be visible.', SalesInvoice.SalesLines."Total Amount Excl. VAT".Caption);
            false:
                if SalesInvoice.SalesLines."Total Amount Excl. VAT".Visible() then
                    Error('%1 should NOT be visible.', SalesInvoice.SalesLines."Total Amount Excl. VAT".Caption);
        end;
        SalesInvoice.Close();
    end;
}