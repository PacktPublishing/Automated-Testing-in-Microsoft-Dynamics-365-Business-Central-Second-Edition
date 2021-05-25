codeunit 80051 "Library - Initialize"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Library - Test Initialize", 'OnBeforeTestSuiteInitialize', '', false, false)]
    local procedure OnBeforeTestSuiteInitializeEvent(CallerCodeunitID: Integer)
    begin
        Initialize(CallerCodeunitID);
    end;

    local procedure Initialize(CallerCodeunitID: Integer)
    var
        LibraryLookupValue: Codeunit "Library - Lookup Value";
        LibrarySetup: Codeunit "Library - Setup";
    begin
        case CallerCodeunitID of
        end;
    end;
}