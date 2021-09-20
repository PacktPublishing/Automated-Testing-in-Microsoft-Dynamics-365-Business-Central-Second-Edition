codeunit 60001 "MySecondTestCodeunit"
{
    Subtype = Test;

    [Test]
    procedure MyNegativeTestFunction()
    begin
        Error('MyNegativeTestFunction');
    end;

    [Test]
    procedure MyPositiveNegativeTestFunction()
    begin
        asserterror Error('MyPositiveNegativeTestFunction');
    end;
}

