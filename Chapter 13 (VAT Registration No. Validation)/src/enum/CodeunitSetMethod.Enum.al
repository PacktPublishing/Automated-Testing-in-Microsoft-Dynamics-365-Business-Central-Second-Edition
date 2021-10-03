enum 60100 "Codeunit Set Method"
{
    Extensible = true;
    Caption = 'Codeunit Set Method';

    value(0; "Default Codeunit")
    {
        Caption = 'Default Codeunit';
    }
    value(1; "From Setup")
    {
        Caption = 'From Setup';
    }
    value(2; "Set with Subscriber")
    {
        Caption = 'Set with Subscriber';
    }
    value(3; "Set with Interface")
    {
        Caption = 'Set with Interface';
    }
}