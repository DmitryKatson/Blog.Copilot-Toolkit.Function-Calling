codeunit 50300 "GPT Booking Copilot Install"
{
    Subtype = Install;

    trigger OnInstallAppPerDatabase()
    begin
        RegisterCapability();
    end;

    local procedure RegisterCapability()
    var
        CopilotCapability: Codeunit "Copilot Capability";
        EnvironmentInformation: Codeunit "Environment Information";
        LearnMoreUrlTxt: Label 'https://katson.com/blog/', Locked = true; //TODO: Update the URL
    begin
        if EnvironmentInformation.IsSaaS() then
            if not CopilotCapability.IsCapabilityRegistered(Enum::"Copilot Capability"::"GPT Booking Copilot") then
                CopilotCapability.RegisterCapability(Enum::"Copilot Capability"::"GPT Booking Copilot", LearnMoreUrlTxt);
    end;
}