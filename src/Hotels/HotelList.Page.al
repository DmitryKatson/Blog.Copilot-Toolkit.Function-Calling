page 50302 "GPT Hotel List"
{

    ApplicationArea = All;
    Caption = 'Hotels';
    PageType = List;
    SourceTable = "GPT Hotel";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                }
                field(Rating; Rec.Rating)
                {
                    ApplicationArea = All;
                }
                field(Amenities; Rec.Amenities)
                {
                    ApplicationArea = All;
                }
                field(Price; Rec.Price)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Reservations)
            {
                ApplicationArea = All;
                Caption = 'Reservations';
                Image = ReservationLedger;
                RunObject = page "GPT Hotel Reservations";
                RunPageLink = "Hotel Code" = field(Code);
            }
        }
    }
}
