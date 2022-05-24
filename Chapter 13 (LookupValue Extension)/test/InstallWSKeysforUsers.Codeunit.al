codeunit 80098 "Install WS Keys for Users"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        SetWebServicesKeyPerUser();
    end;

    local procedure SetWebServicesKeyPerUser()
    var
        User: Record User;
        IdentityManagement: Codeunit "Identity Management";
    begin
        User.SetLoadFields("User Security ID");
        if User.FindSet() then
            repeat
                if IdentityManagement.GetWebServicesKey(User."User Security ID") = '' then
                    IdentityManagement.CreateWebServicesKeyNoExpiry(User."User Security ID");
            until User.Next() = 0;
    end;
}