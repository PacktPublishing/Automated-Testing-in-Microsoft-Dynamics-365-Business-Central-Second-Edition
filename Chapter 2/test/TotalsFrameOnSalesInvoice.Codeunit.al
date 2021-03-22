codeunit 70000 "TotalsFrameOnSalesInvoice"
{
    Subtype = Test;

    [Test]
    procedure HideTotalsFrameOnSalesInvoiceWhenVATBusinesPostingGroupEqualsEXPORT()
    var
        SalesHeader: Record "Sales Header";
        SalesInvoicePage: TestPage "Sales Invoice";
    begin
        SalesHeader."Document Type" := "Sales Document Type"::Invoice;
        SalesHeader.Insert(true);
        SalesHeader.Validate("VAT Bus. Posting Group", 'EXPORT');
        SalesHeader.Modify();

        SalesInvoicePage.OpenView();
        SalesInvoicePage.GoToRecord(SalesHeader);
        if SalesInvoicePage.SalesLines."Total Amount Excl. VAT".Visible() then
            Error('%1 should NOT be visible.', SalesInvoicePage.SalesLines."Total Amount Excl. VAT".Caption);
        SalesInvoicePage.Close();
    end;

    [Test]
    procedure ShowTotalsFrameOnSalesInvoiceWhenVATBusinesPostingGroupNotEqualsEXPORT()
    var
        SalesHeader: Record "Sales Header";
        SalesInvoicePage: TestPage "Sales Invoice";
    begin
        SalesHeader."Document Type" := "Sales Document Type"::Invoice;
        SalesHeader.Insert(true);
        SalesHeader.Validate("VAT Bus. Posting Group", 'DOMESTIC');
        SalesHeader.Modify();

        SalesInvoicePage.OpenView();
        SalesInvoicePage.GoToRecord(SalesHeader);
        if not SalesInvoicePage.SalesLines."Total Amount Excl. VAT".Visible() then
            Error('%1 should be visible.', SalesInvoicePage.SalesLines."Total Amount Excl. VAT".Caption);
        SalesInvoicePage.Close();
    end;
}