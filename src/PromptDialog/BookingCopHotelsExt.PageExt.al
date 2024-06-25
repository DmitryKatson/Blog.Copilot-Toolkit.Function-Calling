pageextension 50300 "GPT Booking Cop. Hotels Ext" extends "GPT Hotel List"
{
    actions
    {
        addlast(Prompting)
        {
            action("GPT Assist")
            {
                Caption = 'Booking Assistant';
                ToolTip = 'Assist with booking using Copilot';
                Image = Sparkle;
                ApplicationArea = All;
                trigger OnAction()
                var
                    BookingAssistantCopilot: Page "GPT Booking Assistant";
                begin
                    BookingAssistantCopilot.RunModal();
                end;
            }
        }
    }
}