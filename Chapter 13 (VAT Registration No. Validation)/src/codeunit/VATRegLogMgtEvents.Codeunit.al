codeunit 60160 "VAT Reg. Log Mgt. Events"
{
    EventSubscriberInstance = Manual;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"VAT Registration Log Mgt. 3", 'OnBeforeCheckVIESForVATNoCodeunit', '', false, false)]
    local procedure OnBeforeCheckVIESForVATNoCodeunit(var VATRegNoSrvCodeunitId: Integer; var IsHandled: Boolean)
    var
        VATRegNoSrvConfig: Record "VAT Reg. No. Srv Config";
    begin
        if IsHandled then
            exit;

        if VATRegNoSrvCodeunitId = 0 then begin
            VATRegNoSrvConfig.Get();
            VATRegNoSrvConfig.TestField("Handling Codeunit ID");
            VATRegNoSrvCodeunitId := VATRegNoSrvConfig."Handling Codeunit ID";
        end;
    end;
}