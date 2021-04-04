codeunit 60051 "MyFifthTestCodeunit.Codeunit"
{
    Subtype = Test;

    [Test]
    procedure DeleteItemLedgerEntry()
    begin
        DeleteILE();
    end;

    [Test]
    [TestPermissions(TestPermissions::Disabled)]
    procedure DeleteItemLedgerEntryTpDisabled()
    begin
        DeleteILE();
    end;

    [Test]
    [TestPermissions(TestPermissions::Restrictive)]
    procedure DeleteItemLedgerEntryTpRestrictive()
    begin
        DeleteILE();
    end;

    [Test]
    [TestPermissions(TestPermissions::NonRestrictive)]
    procedure DeleteItemLedgerEntryTpNonRestrictive()
    begin
        DeleteILE();
    end;

    [Test]
    [TestPermissions(TestPermissions::InheritFromTestCodeunit)]
    procedure DeleteItemLedgerEntryTpInheritFromTestCodeunit()
    begin
        DeleteILE();
    end;

    local procedure DeleteILE()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        ItemLedgerEntry.FindLast();
        ItemLedgerEntry.Delete();
    end;
}