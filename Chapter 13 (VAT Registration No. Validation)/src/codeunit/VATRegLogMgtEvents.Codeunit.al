codeunit 60160 "VAT Reg. Log Mgt. Events"
{
    EventSubscriberInstance = Manual;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"VAT Registration Log Mgt. 2", 'OnBeforeCheckVIESForVATNoCodeunit', '', false, false)]
    local procedure OnBeforeCheckVIESForVATNoCodeunit(var VATRegNoSrvCodeunitId: Integer; var IsHandled: Boolean)
    var
        VATRegNoSrvConfig: Record "VAT Reg. No. Srv Config";
    begin
        if VATRegNoSrvCodeunitId = 0 then begin
            VATRegNoSrvConfig.Get();
            VATRegNoSrvConfig.TestField("Service Codeunit");
            VATRegNoSrvCodeunitId := VATRegNoSrvConfig."Service Codeunit";
        end;
    end;
}