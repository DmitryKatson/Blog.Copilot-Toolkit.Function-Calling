page 50303 "GPT Hotel Reservations"
{
    ApplicationArea = All;
    Caption = 'Reservations';
    PageType = List;
    SourceTable = "GPT Hotel Reservation";
    UsageCategory = Lists;
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Reservation Code"; Rec."Reservation Code")
                {
                    ApplicationArea = All;
                }
                field("Hotel Code"; Rec."Hotel Code")
                {
                    ApplicationArea = All;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Check-In Date"; Rec."Check-In Date")
                {
                    ApplicationArea = All;
                }
                field("Check-Out Date"; Rec."Check-Out Date")
                {
                    ApplicationArea = All;
                }
                field("Number of Rooms"; Rec."Number of Rooms")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
