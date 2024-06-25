page 50300 "GPT Booking Copilot Setup"
{

    Caption = 'Booking Copilot Setup';
    PageType = Card;
    SourceTable = "GPT Booking Copilot Setup";
    InsertAllowed = false;
    DeleteAllowed = false;
    ApplicationArea = All;
    UsageCategory = Administration;


    layout
    {
        area(content)
        {
            group(General)
            {
                field(Endpoint; Rec.Endpoint)
                {
                    ApplicationArea = All;
                    InstructionalText = 'https://[resource].openai.azure.com/';
                }
                field(Deployment; Rec.Deployment)
                {
                    ApplicationArea = All;
                    InstructionalText = 'Enter the deployment name';
                }
                field(SecretKey; SecretKey)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Secret Key';
                    NotBlank = true;
                    ShowMandatory = true;
                    ExtendedDatatype = Masked;
                    trigger OnValidate()
                    begin
                        Rec.SetSecretKeyToIsolatedStorage(SecretKey);
                    end;
                }
            }
        }
    }

    var
        [NonDebuggable]
        SecretKey: Text;


    trigger OnOpenPage()
    begin
        if not Rec.Get() then
            Rec.Insert();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SecretKey := Rec.GetSecretKey();
    end;

}