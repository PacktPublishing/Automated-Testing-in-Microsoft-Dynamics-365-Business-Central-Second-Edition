enum 60100 "Service Handling Type"
{
    Extensible = true;
    Caption = 'Service Handling Type';

    value(0; "Default Codeunit")
    {
        Caption = 'Default Codeunit';
    }
    value(1; "From Setup")
    {
        Caption = 'From Setup';
    }
    value(2; "With Subscriber")
    {
        Caption = 'With Subscriber';
    }
}