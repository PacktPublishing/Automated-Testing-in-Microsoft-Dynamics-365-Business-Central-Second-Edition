codeunit 60050 "MyTestRunnerCodeunit"
{
    Subtype = TestRunner;
    TestIsolation = Codeunit;
    TableNo = "Test Method Line";
    Permissions = TableData "AL Test Suite" = rimd, TableData "Test Method Line" = rimd;

    trigger OnRun()
    begin
        ALTestSuite.Get(Rec."Test Suite");
        CurrentTestMethodLine.Copy(Rec);
        TestRunnerMgt.RunTests(Rec);
    end;

    trigger OnBeforeTestRun(CodeunitId: Integer; CodeunitName: Text; FunctionName: Text; FunctionTestPermissions: TestPermissions): Boolean
    begin
        if IsNull(PermissionTestHelper) then
            PermissionTestHelper := PermissionTestHelper.PermissionTestHelper;

        PermissionTestHelper.Clear();

        case FunctionTestPermissions of
            TestPermissions::Restrictive:
                PermissionTestHelper.AddEffectivePermissionSet('O365 BASIC');
            TestPermissions::NonRestrictive:
                PermissionTestHelper.AddEffectivePermissionSet('O365 BUS FULL ACCESS');
            TestPermissions::Disabled:
                PermissionTestHelper.AddEffectivePermissionSet('SUPER');
        end;

        exit(
          TestRunnerMgt.PlatformBeforeTestRun(
            CodeunitId, CopyStr(CodeunitName, 1, 30), CopyStr(FunctionName, 1, 128), FunctionTestPermissions, ALTestSuite.Name, CurrentTestMethodLine.GetFilter("Line No.")));
    end;

    trigger OnAfterTestRun(CodeunitId: Integer; CodeunitName: Text; FunctionName: Text; FunctionTestPermissions: TestPermissions; IsSuccess: Boolean)
    begin
        if IsNull(PermissionTestHelper) then
            PermissionTestHelper := PermissionTestHelper.PermissionTestHelper;

        if FunctionTestPermissions <> TestPermissions::Disabled then
            PermissionTestHelper.Clear();

        TestRunnerMgt.PlatformAfterTestRun(
          CodeunitId, CopyStr(CodeunitName, 1, 30), CopyStr(FunctionName, 1, 128), FunctionTestPermissions, IsSuccess, ALTestSuite.Name, CurrentTestMethodLine.GetFilter("Line No."));
    end;

    var
        ALTestSuite: Record "AL Test Suite";
        CurrentTestMethodLine: Record "Test Method Line";
        TestRunnerMgt: Codeunit "Test Runner - Mgt";
        PermissionTestHelper: DotNet NavPermissionTestHelper;
}