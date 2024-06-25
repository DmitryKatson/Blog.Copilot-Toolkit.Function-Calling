page 50301 "GPT Booking Assistant"
{
    Caption = 'Book Hotel with Copilot';
    PageType = PromptDialog;
    IsPreview = true;
    Extensible = false;

    layout
    {
        area(Prompt)
        {
            field(InputText; InputText)
            {
                ShowCaption = false;
                MultiLine = true;
                ApplicationArea = All;
            }

        }
        area(Content)
        {
            field(ResponseText; ResponseText)
            {
                MultiLine = true;
                ApplicationArea = All;
                ShowCaption = false;
                Editable = false;
            }
        }
    }
    actions
    {
        area(SystemActions)
        {
            systemaction(Generate)
            {
                Caption = 'Ask';
                trigger OnAction()
                begin
                    GetAnswer();
                end;
            }
        }
        area(PromptGuide)
        {
            group(Availability)
            {
                Caption = 'Availability';
                action(WhatIsAvailableAtCityOnDate)
                {
                    Caption = 'What hotels are available at [city] on [date]?';
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        InputText := 'What hotels are available at ';
                    end;
                }
                action(WhatIsAvailableAtCityOnDateUnderBudget)
                {
                    Caption = 'What hotels are available at [city] on [date] less than [budget]?';
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        InputText := 'What hotels are available at ';
                    end;
                }
            }
            group(Information)
            {
                Caption = 'Hotel Info';
                action(WhatIsThePriceForARoomAtHotelOnDate)
                {
                    Caption = 'What is the price for a room at [hotel] on [date]?';
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        InputText := 'What is the price for a room at ';
                    end;
                }
                action(IsBreakfastIncludedAtHotel)
                {
                    Caption = 'Is breakfast included at [hotel]?';
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        InputText := 'Is breakfast included at ';
                    end;
                }

            }
            // group(Book)
            // {
            //     action(BookHotel)
            //     {
            //         Caption = 'Book a room at [hotel] from [date] to [date]';
            //         ApplicationArea = All;
            //         trigger OnAction()
            //         begin
            //             InputText := 'Book a room at ';
            //         end;
            //     }
            // }
        }
    }

    var
        InputText: Text;
        ResponseText: Text;


    procedure GetAnswer()
    var
        BookingAssistantImpl: Codeunit "GPT Booking Assistant Impl.";
    begin
        BookingAssistantImpl.GetAnswer(InputText, ResponseText);
    end;
}