codeunit 80001 "Library - Messages"
{
    procedure GetFieldOnTableTxt(FieldCaption: Text; TableCaption: Text): Text
    var
        FieldOnTableTxt: Label '%1 on %2';
    begin
        exit(StrSubstNo(
                FieldOnTableTxt,
                FieldCaption,
                TableCaption))
    end;
}