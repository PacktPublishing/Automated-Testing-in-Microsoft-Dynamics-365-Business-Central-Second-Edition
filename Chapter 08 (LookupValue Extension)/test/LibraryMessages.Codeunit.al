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

    procedure GetValueCannotBeFoundInTableTxt(FieldCaption: Text; TableCaption: Text; LookupValueCode: Code[10]; LookupValueTableCaption: Text): Text
    var
        ValueCannotBeFoundInTableTxt: Label 'The field %1 of table %2 contains a value (%3) that cannot be found in the related table (%4).';
    begin
        exit(StrSubstNo(
                ValueCannotBeFoundInTableTxt,
                FieldCaption,
                TableCaption,
                LookupValueCode,
                LookupValueTableCaption))
    end;
}